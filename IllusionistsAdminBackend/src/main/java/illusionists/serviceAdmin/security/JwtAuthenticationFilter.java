package illusionists.serviceAdmin.security;

import io.jsonwebtoken.Claims;
import jakarta.annotation.Nonnull;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    @Override
    protected void doFilterInternal(
            @Nonnull HttpServletRequest request,
            @Nonnull HttpServletResponse response,
            @Nonnull FilterChain filterChain
    ) throws ServletException, IOException {
        String token = resolveToken(request);

        if (token != null) {
            try {
                // [수정] 토큰 유효성 검증 단계를 명시적으로 추가해라 (jwtTokenProvider에 해당 메서드 있어야 함)
                if (jwtTokenProvider.validateToken(token)) {
                    Claims claims = jwtTokenProvider.getTokenClaims(token);

                    // Subject가 숫자가 아닐 경우를 대비한 방어 로직
                    String subject = claims.getSubject();
                    if (subject == null || subject.isEmpty()) {
                        throw new RuntimeException("JWT Subject(ID) is empty");
                    }

                    int userId = Integer.parseInt(subject);
                    String role = claims.get("role", String.class);

                    // 권한 부여 시 ROLE_ 접두사 확인
                    List<SimpleGrantedAuthority> authorities = (role != null)
                        ? List.of(new SimpleGrantedAuthority("ROLE_" + role)) 
                        : Collections.emptyList();

                    Authentication authentication = new UsernamePasswordAuthenticationToken(userId, null, authorities);

                    // 👈 인증 객체 주입 확인 로그 (디버깅용)
                    log.info("Authenticated user ID: {}, Role: {}", userId, role);
                    
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                } else {
                    log.warn("JWT Token validation failed for token: {}", token.substring(0, Math.min(token.length(), 10)) + "...");
                }
            } catch (Exception e) {
                log.error("JWT Authentication failed: {}", e.getMessage());
                // 에러 발생 시 컨텍스트를 확실히 비워라
                SecurityContextHolder.clearContext();
                request.setAttribute("exception", e);
            }
        } else {
            // [분석] 401의 90%는 여기서 발생한다. 헤더에 토큰이 아예 안 들어온 경우다.
            log.debug("No JWT token found in request headers for URI: {}", request.getRequestURI());
        }

        filterChain.doFilter(request, response);
    }

    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}