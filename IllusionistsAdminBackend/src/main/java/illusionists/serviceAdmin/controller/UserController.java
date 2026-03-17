// UserController.java

package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.UserResponseDto;
import illusionists.serviceAdmin.dto.UserUpdateRequestDto;
import illusionists.serviceAdmin.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import java.util.Map;

@Tag(name = "User API", description = "유저 관리")
@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UserController {

    private final UserService userService;

	@Operation(summary = "유저 페이징 조회 (검색 및 필터 포함)")
    @GetMapping("/users/page")
    public ResponseEntity<Page<UserResponseDto>> getUsersPage(
            @AuthenticationPrincipal Integer adminId,
            @RequestParam(required = false) String searchName, // 👈 추가
            @RequestParam(required = false) String serviceType, // 👈 추가
			@RequestParam(required = false) String serviceGroup, // 👈 추가
            @PageableDefault(size = 20) Pageable pageable
    ) {
        // 파라미터 전달
        Page<UserResponseDto> usersPage = userService.getUsersPageByAdminId(adminId, searchName, serviceType, serviceGroup, pageable);
        return ResponseEntity.ok(usersPage);
    }

    @Operation(summary = "유저 엑셀 업로드")
    @PostMapping(value = "/users/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, String>> uploadUserExcel(
            @RequestParam("file") MultipartFile file,
            @RequestParam("serviceGroup") String serviceGroup,
            @RequestPart(value = "image", required = false) MultipartFile image
    ) {
        try {
            userService.uploadUserExcel(file, serviceGroup, image);

            return ResponseEntity.ok(Map.of("message", "엑셀 업로드가 성공적으로 완료되었습니다."));        
        } catch (Exception e) {
            log.error("엑셀 업로드 실패", e);
            return ResponseEntity.badRequest().body(Map.of("error", "업로드 실패: " + e.getMessage()));
        }
    }

    @Operation(summary = "유저 전체 삭제")
    @DeleteMapping("/users")
    public ResponseEntity<String> deleteAllUsers() {
        try {
            userService.deleteAllUsers();
            return ResponseEntity.ok("모든 유저 데이터가 삭제되었습니다.");
        } catch (Exception e) {
            log.error("유저 전체 삭제 실패", e);
            return ResponseEntity.badRequest().body("삭제 실패: " + e.getMessage());
        }
    }

    @Operation(summary = "유저 일괄 수정")
    @PutMapping("/users/batch")
    public ResponseEntity<Map<String, String>> updateUsersBatch(
            @RequestBody List<UserUpdateRequestDto> updateRequests
    ) {
        try {
            userService.updateUsersBatch(updateRequests); // 주석 해제 완료
			return ResponseEntity.ok(Map.of("message", updateRequests.size() + "건의 유저 데이터가 일괄 수정되었습니다."));
		} catch (Exception e) {
            log.error("유저 일괄 수정 실패", e);
			return ResponseEntity.badRequest().body(Map.of("error", "수정 실패: " + e.getMessage()));
		}
    }

    @Operation(summary = "유저 선택 일괄 삭제")
    @DeleteMapping("/users/batch") 
    public ResponseEntity<Map<String, String>> deleteUsersBatch(
            @RequestBody Map<String, List<Integer>> payload
    ) {
        try {
            List<Integer> ids = payload.get("ids");
            if (ids == null || ids.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "삭제할 ID가 없습니다."));
            }
            userService.deleteUsersBatch(ids); // 주석 해제 완료
            return ResponseEntity.ok(Map.of("message", ids.size() + "명의 유저가 삭제되었습니다."));
        } catch (Exception e) {
            log.error("유저 일괄 삭제 실패", e);
            return ResponseEntity.badRequest().body(Map.of("error", "삭제 실패: " + e.getMessage()));
        }
    }

    @Operation(summary = "필터 조건 유저 일괄 삭제")
    @DeleteMapping("/users/filter-delete") // 👈 경로를 명확하게 수정
    public ResponseEntity<Map<String, String>> deleteUsersByFilter(
            @RequestParam String groupName,
            @RequestParam String serviceType
    ) {
        try {
            userService.deleteUsersByFilter(groupName, serviceType);
            return ResponseEntity.ok(Map.of("message", "조건에 맞는 유저 데이터가 삭제되었습니다."));
        } catch (Exception e) {
            log.error("필터 삭제 실패", e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}