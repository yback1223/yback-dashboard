package illusionists.serviceAdmin.config;

import illusionists.serviceAdmin.entity.UserRole;
import illusionists.serviceAdmin.security.JwtAuthenticationFilter;
import illusionists.serviceAdmin.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.AuthenticationEntryPoint; // [필수 Import]
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.www.BasicAuthenticationEntryPoint; // [필수 Import]
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.cors.CorsUtils;
import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 0. 스웨거 접속용 계정 (메모리)
    @Bean
    public UserDetailsService userDetailsService() {
        UserDetails admin = User.builder()
                .username("illusionist_admin")
                .password(passwordEncoder().encode("illusionist_admin_password"))
                // UserRole.ILLUSIONIST.name()이 정확하지 않을 수 있으니, 확실한 문자열 "ADMIN"으로 테스트 권장
                .roles("ADMIN") 
                .build();
        return new InMemoryUserDetailsManager(admin);
    }

    // ✅ [핵심] 403 대신 팝업을 띄우게 만드는 "강제 진입점"
    @Bean
    public AuthenticationEntryPoint swaggerAuthenticationEntryPoint() {
        BasicAuthenticationEntryPoint entryPoint = new BasicAuthenticationEntryPoint();
        entryPoint.setRealmName("Swagger UI Realm"); // 팝업창에 뜰 제목
        return entryPoint;
    }

    // 1. 스웨거 전용 보안 체인 (팝업 로그인 강제 적용)
    @Bean
    @Order(1)
    public SecurityFilterChain swaggerFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/swagger-ui/**", "/v3/api-docs/**") // 이 주소들만 납치
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().authenticated() // 로그인 안 하면 못 들어감
                )
                .httpBasic(basic -> basic
                        .authenticationEntryPoint(swaggerAuthenticationEntryPoint()) // 팝업 설정 연결
                )
                // 🔥 여기가 제일 중요! 예외(403)가 터지면 무조건 팝업 띄우게 강제함
                .exceptionHandling(handler -> handler
                        .authenticationEntryPoint(swaggerAuthenticationEntryPoint())
                );

        return http.build();
    }

    // 2. API 전용 보안 체인 (기존 유지)
    @Bean
    @Order(2)
    public SecurityFilterChain apiFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(CorsUtils::isPreFlightRequest).permitAll()
                        .requestMatchers("/api/login", "/api/auth/**", "/api/logout", "/api/signup", "/api/service-groups/**").permitAll()
                        .anyRequest().authenticated()
                )
                // 여기는 팝업 뜨면 안 되니까 httpBasic 없음
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