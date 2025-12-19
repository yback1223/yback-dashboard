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
        Server prodServer = new Server();
        prodServer.setUrl("https://dashboard.ainuri.kr");
        prodServer.setDescription("운영 서버");

        Server localServer = new Server();
        localServer.setUrl("http://localhost:8080");
        localServer.setDescription("로컬 테스트");

        return new OpenAPI()
                .servers(List.of(prodServer, localServer));
    }
}