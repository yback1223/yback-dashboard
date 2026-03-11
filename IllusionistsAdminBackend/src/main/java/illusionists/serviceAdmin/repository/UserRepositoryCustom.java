package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.User;
import java.util.List;

public interface UserRepositoryCustom {
	List<User> findAllByServiceGroupNames(List<String> serviceGroupNames);
}