package illusionists.serviceAdmin.dto;

import lombok.Builder;

public class AuthDto {

	public record LoginRequest(
			String id,
			String password
	) {}

	@Builder
	public record LoginResponse(
			String accessToken,
			String refreshToken,
			String username,
			String university,
			String userRole
	) {}

	public record TokenRefreshRequest(String refreshToken) {}
	public record SignUpRequest(
			String loginId,       // 로그인 ID
			String password,       // 비밀번호
			String username,           // 관리자 실명 (예: 김관리)
			String role,
			String serviceGroupName // 소속 학교 이름 (예: 건국대학교)
	) {}
}