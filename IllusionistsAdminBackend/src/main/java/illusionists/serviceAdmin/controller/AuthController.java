package illusionists.serviceAdmin.controller;

import illusionists.serviceAdmin.dto.AuthDto;
import illusionists.serviceAdmin.service.AuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class AuthController {

	private final AuthService authService;

	@PostMapping("/login")
	public ResponseEntity<AuthDto.LoginResponse> login(@RequestBody AuthDto.LoginRequest request) {
		AuthDto.LoginResponse response = authService.login(request);
		return ResponseEntity.ok(response);
	}

	@PostMapping("/auth/refresh")
	public ResponseEntity<AuthDto.LoginResponse> refresh(@RequestBody AuthDto.TokenRefreshRequest request) {
		return ResponseEntity.ok(authService.refresh(request));
	}

	@PostMapping("/logout")
	public ResponseEntity<Void> logout(@AuthenticationPrincipal Integer userId) {
		authService.logout(userId);
		return ResponseEntity.ok().build();
	}

	@PostMapping("/signup")
	public ResponseEntity<String> signup(@RequestBody AuthDto.SignUpRequest request) {
		authService.signup(request);
		return ResponseEntity.ok("회원가입이 성공적으로 완료되었습니다.");
	}
}