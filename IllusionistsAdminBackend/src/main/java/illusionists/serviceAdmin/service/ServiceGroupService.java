package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.entity.AdminUser;
import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.dto.ServiceGroupCreateRequest;
import illusionists.serviceAdmin.dto.ServiceGroupResponse;
import illusionists.serviceAdmin.repository.AdminUserRepository;
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServiceGroupService {

    private final ServiceGroupRepository serviceGroupRepository;
    private final AdminUserRepository adminUserRepository;

    // 생성
    @Transactional
    public ServiceGroupResponse createServiceGroup(ServiceGroupCreateRequest request) {
        if (serviceGroupRepository.existsByName(request.getName())) {
            throw new IllegalArgumentException("이미 존재하는 그룹명입니다: " + request.getName());
        }

        ServiceGroup serviceGroup = ServiceGroup.builder()
                .name(request.getName())
                .build();

        ServiceGroup savedGroup = serviceGroupRepository.save(serviceGroup);
        return new ServiceGroupResponse(savedGroup);
    }

    // 삭제 (ID가 int)
    @Transactional
    public void deleteServiceGroup(int id) {
        ServiceGroup serviceGroup = serviceGroupRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 그룹을 찾을 수 없습니다. id=" + id));
        
        serviceGroupRepository.delete(serviceGroup);
    }

    @Transactional
    public void connectAdminUserToGroups(Integer adminId, List<String> groupNames) {
        AdminUser admin = adminUserRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 관리자입니다. ID: " + adminId));

        List<ServiceGroup> targetGroups = groupNames.stream()
                .map(name -> serviceGroupRepository.findByName(name)
                        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 서비스 그룹입니다: " + name)))
                .toList();

        List<ServiceGroup> currentGroups = admin.getGroups();
        
        for (ServiceGroup group : targetGroups) {
            if (!currentGroups.contains(group)) {
                currentGroups.add(group);
            }
        }
    }

    @Transactional
    public void disconnectAdminUserFromGroups(Integer adminId, List<String> groupNames) {
        AdminUser admin = adminUserRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 관리자입니다. ID: " + adminId));
        List<ServiceGroup> targetGroups = groupNames.stream()
                .map(name -> serviceGroupRepository.findByName(name)
                        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 서비스 그룹입니다: " + name)))
                .toList();

        List<ServiceGroup> currentGroups = admin.getGroups();
        for (ServiceGroup group : targetGroups) {
            if (currentGroups.contains(group)) {
                currentGroups.remove(group);
            }
        }
    }

    public List<String> getServiceGroupNamesByAdminId(Integer adminId) {
        AdminUser admin = adminUserRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 관리자입니다. ID: " + adminId));
        return admin.getGroups().stream()
                .map(ServiceGroup::getName)
                .toList();
    }
}