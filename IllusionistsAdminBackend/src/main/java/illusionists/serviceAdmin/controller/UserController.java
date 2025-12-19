package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.UserResponseDto;
import illusionists.serviceAdmin.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal; // 이거 필수
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UserController {

	private final UserService userService;

	@GetMapping("/users")
	public ResponseEntity<List<UserResponseDto>> getUsers(
			@AuthenticationPrincipal Integer adminId
	) {
		List<UserResponseDto> users = userService.getUsersByAdminId(adminId);

		return ResponseEntity.ok(users);
	}

	@PostMapping(value = "/users/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE) // [핵심] consumes 추가
	public ResponseEntity<String> uploadUserExcel(
			@RequestParam("file") MultipartFile file,
			@RequestParam("serviceGroup") String serviceGroup
	) {
		try {
			userService.uploadUserExcel(file, serviceGroup);
			return ResponseEntity.ok("엑셀 업로드가 성공적으로 완료되었습니다.");
		} catch (Exception e) {
			log.error("엑셀 업로드 실패", e);
			return ResponseEntity.badRequest().body("업로드 실패: " + e.getMessage());
		}
	}

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
}