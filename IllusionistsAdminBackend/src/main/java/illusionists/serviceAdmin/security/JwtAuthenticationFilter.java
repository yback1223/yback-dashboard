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
				Claims claims = jwtTokenProvider.getTokenClaims(token);

				int userId = Integer.parseInt(claims.getSubject());
				String role = claims.get("role", String.class);

				List<SimpleGrantedAuthority> authorities = (role != null)
						? List.of(new SimpleGrantedAuthority(role))
						: Collections.emptyList();

				Authentication authentication = new UsernamePasswordAuthenticationToken(userId, null, authorities);

				SecurityContextHolder.getContext().setAuthentication(authentication);
			} catch (Exception e) {
				log.error("Invalid JWT Token: {}", e.getMessage());
				request.setAttribute("exception", e);
			}
		}

		filterChain.doFilter(request, response);
	}

	private String resolveToken(HttpServletRequest request) {
		String bearerToken = request.getHeader("Authorization");
		if (bearerToken != null && bearerToken.startsWith("Bearer ")) return bearerToken.substring(7);
		return null;
	}
}
