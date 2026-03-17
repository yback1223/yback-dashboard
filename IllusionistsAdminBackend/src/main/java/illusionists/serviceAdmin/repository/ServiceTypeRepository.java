// ServiceTypeRepository.java

package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.ServiceType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ServiceTypeRepository extends JpaRepository<ServiceType, Integer> {
    Optional<ServiceType> findByName(String name);
}