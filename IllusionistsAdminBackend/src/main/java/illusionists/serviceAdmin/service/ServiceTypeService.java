package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.entity.ServiceType;
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import illusionists.serviceAdmin.repository.ServiceTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServiceTypeService {

    private final ServiceTypeRepository serviceTypeRepository;
    private final ServiceGroupRepository serviceGroupRepository;

    public List<Map<String, String>> getAvailableTypes(List<String> groupNames) {
        Set<ServiceType> typeSet = new HashSet<>();

        if (groupNames == null) {
            // 💡 [집행] 그룹 조건이 없으면 시스템의 모든 타입 합집합 조회
            typeSet.addAll(serviceTypeRepository.findAll());
        } else {
            // 💡 [집행] 전달된 그룹 리스트를 순회하며 각 그룹의 타입들을 합집합(Set)에 추가
            for (String groupName : groupNames) {
                serviceGroupRepository.findByName(groupName)
                    .ifPresent(group -> typeSet.addAll(group.getServiceTypes()));
            }
        }

        // 이름순 정렬 및 DTO 변환
        return typeSet.stream()
                .map(t -> Map.of("name", t.getName()))
                .sorted(Comparator.comparing(m -> m.get("name")))
                .collect(Collectors.toList());
    }
}
