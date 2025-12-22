package illusionists.serviceAdmin.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server; // 추가됨
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        String jwtSchemeName = "JWT";

        // 1. 보안 요구사항 설정
        SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwtSchemeName);

        // 2. 보안 스키마(JWT) 설정
        Components components = new Components()
                .addSecuritySchemes(jwtSchemeName, new SecurityScheme()
                        .name(jwtSchemeName)
                        .type(SecurityScheme.Type.HTTP)
                        .scheme("bearer")
                        .bearerFormat("JWT"));

        // 3. 서버 리스트 설정 (Nginx 포트 반영)
        Server localServer = new Server();
        localServer.setUrl("http://localhost:8001");
        localServer.setDescription("로컬 테스트 (Nginx 포트)");

        Server prodServer = new Server();
        prodServer.setUrl("https://dashboard.ainuri.kr");
        prodServer.setDescription("운영 서버");

        return new OpenAPI()
                .info(new Info()
                        .title("Admin API")
                        .description("AI 솔루션 계정 관리자 API 문서")
                        .version("v1.0.0"))
                .addSecurityItem(securityRequirement)
                .components(components)
                .servers(List.of(localServer, prodServer)); // 서버 리스트를 명시적으로 등록
    }
}