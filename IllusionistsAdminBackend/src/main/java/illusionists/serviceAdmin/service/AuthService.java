// AuthService.java

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
import java.util.List;
import java.util.stream.Collectors;

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

		return buildLoginResponse(admin, admin.getGroups(), accessToken, refreshToken);
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

		return buildLoginResponse(admin, admin.getGroups(), newAccessToken, newRefreshToken);
	}

	private AuthDto.LoginResponse buildLoginResponse(AdminUser admin, List<ServiceGroup> groups, String accessToken, String refreshToken) {
        
		List<String> names = groups.stream()
				.map(ServiceGroup::getName)
				.collect(Collectors.toList());
		
		List<String> imageUrls = groups.stream()
				.map(ServiceGroup::getImageUrl)
				.collect(Collectors.toList());

		// 대표 이미지 결정 로직 (프론트엔드 로직과 동기화)
		String representativeImageUrl;
		if (groups.size() > 1) {
			// 그룹이 여러 개일 경우 시스템 기본 로고 (Nginx에 미리 올려둔 파일 경로)
			representativeImageUrl = "/assets/images/illusionists_logo_2.png"; 
		} else if (groups.size() == 1) {
			// 그룹이 하나일 경우 해당 그룹의 로고
			representativeImageUrl = groups.get(0).getImageUrl();
		} else {
			representativeImageUrl = "/assets/images/default_logo.png";
		}

		return AuthDto.LoginResponse.builder()
				.accessToken(accessToken)
				.refreshToken(refreshToken)
				.username(admin.getUsername())
				.serviceGroupNames(names)
				.serviceGroupImageUrls(imageUrls)
				.serviceGroupImageUrl(representativeImageUrl) // 프론트엔드가 바로 쓸 수 있게 제공
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

        List<ServiceGroup> groups = request.serviceGroupNames().stream()
                .map(name -> serviceGroupRepository.findByName(name)
                        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 그룹입니다: " + name)))
                .toList();

        if (groups.isEmpty()) {
            throw new IllegalArgumentException("최소 하나 이상의 서비스 그룹을 선택해야 합니다.");
        }

        AdminUser newAdmin = AdminUser.builder()
                .loginId(request.loginId())
                .password(passwordEncoder.encode(request.password()))
                .username(request.username())
                .groups(groups)
                .role(UserRole.valueOf(request.role()))
                .build();

        adminUserRepository.save(newAdmin);
    }
}