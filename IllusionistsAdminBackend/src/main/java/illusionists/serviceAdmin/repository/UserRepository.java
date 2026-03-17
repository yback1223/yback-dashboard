// UserRepository.java

package illusionists.serviceAdmin.repository;

import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

public interface UserRepository extends JpaRepository<User, Integer> {

    // 마스터 관리자용 필터 조회
    @Query("SELECT u FROM User u WHERE " +
           "(:serviceGroup IS NULL OR u.group.name = :serviceGroup) AND " +
           "(:searchName IS NULL OR :searchName = '' OR u.name LIKE %:searchName%) AND " +
           "(:serviceType IS NULL OR u.serviceType.name = :serviceType)")
    Page<User> findAllByFilters(
            @Param("searchName") String searchName,
            @Param("serviceType") String serviceType,
            @Param("serviceGroup") String serviceGroup,
            Pageable pageable);

    List<User> findAllByGroup(ServiceGroup group);

    // 일반 관리자용 필터 조회 (권한 그룹 제한)
    @Query("SELECT u FROM User u WHERE " +
           "u.group IN :groups AND " +
           "(:serviceGroup IS NULL OR u.group.name = :serviceGroup) AND " +
           "(:searchName IS NULL OR :searchName = '' OR u.name LIKE %:searchName%) AND " +
           "(:serviceType IS NULL OR u.serviceType.name = :serviceType)")
    Page<User> findByGroupsAndFilters(
            @Param("groups") List<ServiceGroup> groups,
            @Param("searchName") String searchName,
            @Param("serviceType") String serviceType,
            @Param("serviceGroup") String serviceGroup,
            Pageable pageable);

    // 🚨 [수정] 정밀 타격 벌크 삭제 (그룹/타입 전체 대응)
    @Transactional
    @Modifying
    @Query("DELETE FROM User u WHERE " +
           "(:groupName IS NULL OR u.group.name = :groupName) AND " +
           "(:serviceType IS NULL OR u.serviceType.name = :serviceType)")
    void deleteByFilter(
            @Param("groupName") String groupName, 
            @Param("serviceType") String serviceType);
}