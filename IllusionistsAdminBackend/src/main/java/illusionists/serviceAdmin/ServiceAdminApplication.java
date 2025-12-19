package illusionists.serviceAdmin;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing // Base 엔티티의 생성일/수정일 자동 기록 활성화
@SpringBootApplication
public class ServiceAdminApplication {

	public static void main(String[] args) {
		SpringApplication.run(ServiceAdminApplication.class, args);
	}
}