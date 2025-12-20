package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.AuthDto;
import illusionists.serviceAdmin.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth API", description = "인증 관리")
@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class AuthController {

	private final AuthService authService;

	@Operation(summary = "로그인")
	@PostMapping("/login")
	public ResponseEntity<AuthDto.LoginResponse> login(@RequestBody AuthDto.LoginRequest request) {
		AuthDto.LoginResponse response = authService.login(request);
		return ResponseEntity.ok(response);
	}

	@Operation(summary = "리프레시 토큰 갱신")
	@PostMapping("/auth/refresh")
	public ResponseEntity<AuthDto.LoginResponse> refresh(@RequestBody AuthDto.TokenRefreshRequest request) {
		return ResponseEntity.ok(authService.refresh(request));
	}

	@Operation(summary = "로그아웃")
	@PostMapping("/logout")
	public ResponseEntity<Void> logout(@AuthenticationPrincipal Integer userId) {
		authService.logout(userId);
		return ResponseEntity.ok().build();
	}

	@Operation(summary = "회원가입")
	@PostMapping("/signup")
	public ResponseEntity<String> signup(@RequestBody AuthDto.SignUpRequest request) {
		authService.signup(request);
		return ResponseEntity.ok("회원가입이 성공적으로 완료되었습니다.");
	}
}