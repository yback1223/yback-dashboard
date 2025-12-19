package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.AdminUser;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AdminUserRepository extends JpaRepository<AdminUser, Integer> {
	Optional<AdminUser> findByLoginId(String loginId);
}