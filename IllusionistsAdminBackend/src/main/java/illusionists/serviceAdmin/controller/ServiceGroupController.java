package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.AdminUserConnectRequest;
import illusionists.serviceAdmin.dto.ServiceGroupCreateRequest;
import illusionists.serviceAdmin.dto.ServiceGroupResponse;
import illusionists.serviceAdmin.service.ServiceGroupService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Service Group API", description = "서비스 그룹 관리")
@RestController
@RequestMapping("/api/service-groups")
@RequiredArgsConstructor
public class ServiceGroupController {

    private final ServiceGroupService serviceGroupService;

    @Operation(summary = "서비스 그룹 생성")
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ServiceGroupResponse> create(
            @RequestPart("request") @Valid ServiceGroupCreateRequest request,
            @RequestPart("image") MultipartFile image) {
        
        ServiceGroupResponse response = serviceGroupService.createServiceGroup(request, image);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "서비스 그룹 이름 조회")
    @GetMapping
    public ResponseEntity<List<String>> getServiceGroupNames(@AuthenticationPrincipal Integer userId) {
        List<String> serviceGroupNames = serviceGroupService.getServiceGroupNamesByAdminId(userId);
        return ResponseEntity.ok(serviceGroupNames);
    }

    @Operation(summary = "서비스 그룹과 관리자 연결")
    @PostMapping("/connect")
    public ResponseEntity<Void> connectAdminUser(@AuthenticationPrincipal Integer userId, @RequestBody @Valid AdminUserConnectRequest request) {
        serviceGroupService.connectAdminUserToGroups(userId, request.getGroupNames());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "서비스 그룹과 관리자 연결 해제")
    @PostMapping("/disconnect")
    public ResponseEntity<Void> disconnectAdminUser(@AuthenticationPrincipal Integer userId, @RequestBody @Valid AdminUserConnectRequest request) {
        serviceGroupService.disconnectAdminUserFromGroups(userId, request.getGroupNames());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "서비스 그룹 삭제")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable int id) {
        serviceGroupService.deleteServiceGroup(id);
        return ResponseEntity.noContent().build();
    }
}