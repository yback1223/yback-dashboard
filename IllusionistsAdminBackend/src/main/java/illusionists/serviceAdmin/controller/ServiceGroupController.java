package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.ServiceGroupCreateRequest;
import illusionists.serviceAdmin.dto.ServiceGroupResponse;
import illusionists.serviceAdmin.service.ServiceGroupService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Service Group API", description = "서비스 그룹 관리")
@RestController
@RequestMapping("/api/service-groups")
@RequiredArgsConstructor
public class ServiceGroupController {

    private final ServiceGroupService serviceGroupService;

    @Operation(summary = "서비스 그룹 생성")
    @PostMapping
    public ResponseEntity<ServiceGroupResponse> create(@RequestBody @Valid ServiceGroupCreateRequest request) {
        ServiceGroupResponse response = serviceGroupService.createServiceGroup(request);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "서비스 그룹 삭제")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable int id) {
        serviceGroupService.deleteServiceGroup(id);
        return ResponseEntity.noContent().build();
    }
}