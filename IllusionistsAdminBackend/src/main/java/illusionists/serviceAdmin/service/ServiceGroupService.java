package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.dto.ServiceGroupCreateRequest;
import illusionists.serviceAdmin.dto.ServiceGroupResponse;
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServiceGroupService {

    private final ServiceGroupRepository serviceGroupRepository;

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
}