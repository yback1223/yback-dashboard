package illusionists.serviceAdmin.config;

import illusionists.serviceAdmin.entity.UserRole;
import illusionists.serviceAdmin.security.JwtAuthenticationFilter;
import illusionists.serviceAdmin.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.cors.CorsUtils;
import java.util.List;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.core.userdetails.User;
import static org.springframework.security.config.Customizer.withDefaults; // [필수] import 추가

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 1. 스웨거 접속용 계정 (메모리에 생성)
    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails admin = User.builder()
                .username("illusionist_admin")
                .password(passwordEncoder().encode("illusionist_admin_password")) 
                .roles(UserRole.ILLUSIONIST.name()) 
                .build();
        return new InMemoryUserDetailsManager(admin);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Preflight 허용
                        .requestMatchers(CorsUtils::isPreFlightRequest).permitAll()

                        // 로그인, 토큰 갱신, 회원가입 등은 누구나 접근 가능
                        .requestMatchers("/api/login", "/api/auth/**", "/api/logout", "/api/signup", "/api/service-groups/**").permitAll()

                        // ❌ [삭제됨] 여기에 있던 "/swagger-ui/**" permitAll을 지워야 잠깁니다!
                        // 지웠기 때문에 자동으로 아래 .anyRequest().authenticated()에 걸리게 됩니다.

                        // 나머지는 인증 필요 (스웨거 포함)
                        .anyRequest().authenticated()
                )
                // ✅ [추가] 브라우저 팝업 로그인 활성화 (이게 없으면 403 페이지만 뜨고 입력창이 안 나옴)
                .httpBasic(withDefaults()) 
                
                .userDetailsService(userDetailsService()) // 위에서 만든 계정 설정 연결
                .addFilterBefore(
                        new JwtAuthenticationFilter(jwtTokenProvider),
                        UsernamePasswordAuthenticationFilter.class
                );

        return http.build();
    }
    
    // (CORS 설정은 그대로 유지)
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(List.of("*"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        configuration.addExposedHeader("Authorization");
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}