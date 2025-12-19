package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.security.RefreshToken;
import org.springframework.data.repository.CrudRepository;

public interface RefreshTokenRepository extends CrudRepository<RefreshToken, Integer> {
}
