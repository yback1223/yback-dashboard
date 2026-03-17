// ServiceGroupService.java

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
import java.util.UUID;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.File;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServiceGroupService {

    private final ServiceGroupRepository serviceGroupRepository;
    private final AdminUserRepository adminUserRepository;

    @Transactional
    public ServiceGroupResponse createServiceGroup(ServiceGroupCreateRequest request, MultipartFile image) {
        if (serviceGroupRepository.existsByName(request.getName())) {
            throw new IllegalArgumentException("이미 존재하는 그룹명입니다: " + request.getName());
        }
    
        // 1. 파일 저장 처리
        String fileName = saveImage(image);
        // 2. 브라우저에서 접근 가능한 URL 생성 (캐시 방지를 위해 타임스탬프 쿼리 포함)
        String imageUrl = "/assets/images/" + fileName + "?v=" + System.currentTimeMillis();
    
        ServiceGroup serviceGroup = ServiceGroup.builder()
                .name(request.getName())
                .imageUrl(imageUrl) // 생성된 URL 저장
                .build();
    
        ServiceGroup savedGroup = serviceGroupRepository.save(serviceGroup);
        return new ServiceGroupResponse(savedGroup);
    }
    
    public String saveImage(MultipartFile image) {
        if (image == null || image.isEmpty()) return null;
        
        try {
            // 루트의 assets/images 폴더 경로 설정
            String uploadDir = "/app/assets/images/"; 
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
    
            // 파일명 중복 방지 (UUID 사용)
            String originalName = image.getOriginalFilename();
            String extension = originalName.substring(originalName.lastIndexOf("."));
            String savedName = UUID.randomUUID().toString() + extension;
    
            Path filePath = Paths.get(uploadDir + savedName);
            Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
    
            return savedName;
        } catch (IOException e) {
            throw new RuntimeException("이미지 저장 실패: " + e.getMessage());
        }
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