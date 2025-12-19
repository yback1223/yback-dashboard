package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.ServiceGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ServiceGroupRepository extends JpaRepository<ServiceGroup, Integer> {
	Optional<ServiceGroup> findByName(String name);
}