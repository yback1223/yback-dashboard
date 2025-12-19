package illusionists.serviceAdmin.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

	@Bean
	public OpenAPI openAPI() {
		String jwtSchemeName = "JWT";

		// 1. 헤더에 토큰을 넣는 방식 정의
		SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwtSchemeName);

		// 2. 보안 스키마 설정
		Components components = new Components()
				.addSecuritySchemes(jwtSchemeName, new SecurityScheme()
						.name(jwtSchemeName)
						.type(SecurityScheme.Type.HTTP) // HTTP 방식
						.scheme("bearer")
						.bearerFormat("JWT")); // Bearer Token 방식

		return new OpenAPI()
				.info(new Info().title("Admin API").version("v1.0.0"))
				.addSecurityItem(securityRequirement) // 이 API는 보안이 필요하다고 명시
				.components(components);
	}
}