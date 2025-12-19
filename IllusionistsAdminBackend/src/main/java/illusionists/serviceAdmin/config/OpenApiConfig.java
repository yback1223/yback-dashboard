package illusionists.serviceAdmin.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .servers(List.of(
                    new Server().url("https://dashboard.ainuri.kr").description("Production Server"),
                    new Server().url("http://localhost:8080").description("Local Server")
                ));
    }
}