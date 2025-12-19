package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

// JpaRepository와 커스텀 인터페이스를 다중 상속
public interface UserRepository extends JpaRepository<User, Integer>, UserRepositoryCustom {
	// 이제 findAllByUniversityName 메서드를 바로 쓸 수 있음
}