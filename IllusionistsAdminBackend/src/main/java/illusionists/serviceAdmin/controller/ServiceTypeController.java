package illusionists.serviceAdmin.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Map;
import illusionists.serviceAdmin.service.ServiceTypeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;


@Tag(name = "Service Type API", description = "서비스 타입 조회")
@RestController
@RequestMapping("/api/service-types")
@RequiredArgsConstructor
public class ServiceTypeController {

    private final ServiceTypeService serviceTypeService;

    @Operation(summary = "그룹 리스트별 서비스 타입 합집합 조회", description = "그룹명 리스트를 받아 포함된 모든 타입의 합집합을 반환한다.")
    @GetMapping
    public ResponseEntity<List<Map<String, String>>> getServiceTypes(
            @RequestParam(required = false) List<String> groupNames // 🚨 List로 변경
    ) {
        // "전체"가 포함되어 있거나 리스트가 비어있으면 null로 처리하여 전체 조회 유도
        List<String> filterGroups = (groupNames == null || groupNames.isEmpty() || groupNames.contains("전체")) 
            ? null 
            : groupNames;
        
        List<Map<String, String>> types = serviceTypeService.getAvailableTypes(filterGroups);
        return ResponseEntity.ok(types);
    }
}
