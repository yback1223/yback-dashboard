package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.dto.AuthDto;
import illusionists.serviceAdmin.entity.AdminUser;
import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.entity.UserRole;
import illusionists.serviceAdmin.repository.AdminUserRepository;
import illusionists.serviceAdmin.repository.RefreshTokenRepository; // 추가
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import illusionists.serviceAdmin.security.JwtTokenProvider;
import illusionists.serviceAdmin.security.RefreshToken; // 추가
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AuthService {

	private final AdminUserRepository adminUserRepository;
	private final RefreshTokenRepository refreshTokenRepository;
	private final ServiceGroupRepository serviceGroupRepository;
	private final JwtTokenProvider jwtTokenProvider;
	private final PasswordEncoder passwordEncoder;

	@Transactional
	public AuthDto.LoginResponse login(AuthDto.LoginRequest request) {
		AdminUser admin = adminUserRepository.findByLoginId(request.id())
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 아이디입니다."));

		if (!passwordEncoder.matches(request.password(), admin.getPassword())) {
			throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
		}

		int adminId = admin.getId();
		String accessToken = jwtTokenProvider.createAccessToken(adminId, admin.getRole());
		String refreshToken = jwtTokenProvider.createRefreshToken(adminId, admin.getRole());

		refreshTokenRepository.save(new RefreshToken(
				adminId,
				refreshToken,
				jwtTokenProvider.getRefreshTokenExpirationSeconds()
		));

		return buildLoginResponse(admin, accessToken, refreshToken);
	}

	@Transactional
	public AuthDto.LoginResponse refresh(AuthDto.TokenRefreshRequest request) {
		String requestRefreshToken = request.refreshToken();

		if (!jwtTokenProvider.validateToken(requestRefreshToken)) {
			throw new IllegalArgumentException("유효하지 않은 Refresh Token입니다.");
		}

		int userId = jwtTokenProvider.getUserIdFromToken(requestRefreshToken);

		RefreshToken redisToken = refreshTokenRepository.findById(userId)
				.orElseThrow(() -> new IllegalArgumentException("만료되거나 존재하지 않는 Refresh Token입니다."));

		if (!redisToken.getRefreshToken().equals(requestRefreshToken)) {
			log.warn("토큰 불일치 감지. User ID: {}", userId);
			throw new IllegalArgumentException("토큰 정보가 일치하지 않습니다.");
		}

		AdminUser admin = adminUserRepository.findById(userId)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

		String newAccessToken = jwtTokenProvider.createAccessToken(userId, admin.getRole());
		String newRefreshToken = jwtTokenProvider.createRefreshToken(userId, admin.getRole());

		refreshTokenRepository.save(new RefreshToken(
				userId,
				newRefreshToken,
				jwtTokenProvider.getRefreshTokenExpirationSeconds()
		));

		return buildLoginResponse(admin, newAccessToken, newRefreshToken);
	}

	private AuthDto.LoginResponse buildLoginResponse(AdminUser admin, String accessToken, String refreshToken) {
		return AuthDto.LoginResponse.builder()
				.accessToken(accessToken)
				.refreshToken(refreshToken)
				.username(admin.getUsername())
				.university(admin.getGroup().getName())
				.userRole(admin.getRole().name())
				.build();
	}

	@Transactional
	public void logout(int userId) {
		refreshTokenRepository.deleteById(userId);
	}

	@Transactional
	public void signup(AuthDto.SignUpRequest request) {
		if (adminUserRepository.findByLoginId(request.loginId()).isPresent()) {
			throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
		}

		ServiceGroup group = serviceGroupRepository.findByName(request.serviceGroupName())
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 학교(서비스 그룹)입니다."));

		AdminUser newAdmin = AdminUser.builder()
				.loginId(request.loginId())
				.password(passwordEncoder.encode(request.password()))
				.username(request.username())
				.group(group)
				.role(UserRole.valueOf(request.role()))
				.build();

		adminUserRepository.save(newAdmin);
	}
}