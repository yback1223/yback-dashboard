package illusionists.serviceAdmin.security;

import illusionists.serviceAdmin.entity.UserRole;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.SignatureException;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Slf4j
@Component
public class JwtTokenProvider {

	@Value("${jwt.secret}")
	private String secretKey;
	private final long REFRESH_TOKEN_VALID_TIME = 7 * 24 * 60 * 60 * 1000L;

	private Key key;

	@PostConstruct
	public void init() {
		byte[] keyBytes = Base64.getDecoder().decode(secretKey);
		this.key = Keys.hmacShaKeyFor(keyBytes);
	}

	public String createAccessToken(int userId, UserRole role) {
		// 30분
		long ACCESS_TOKEN_VALID_TIME = 30 * 60 * 1000L;
		return createToken(userId, role, ACCESS_TOKEN_VALID_TIME);
	}

	public String createRefreshToken(int userId, UserRole role) {
		// 7일
		return createToken(userId, role, REFRESH_TOKEN_VALID_TIME);
	}

	public String createToken(int userId, UserRole role, long validTime) {
		Claims claims = Jwts.claims()
				.subject(String.valueOf(userId))
				.add("role", role)
				.build();

		Date now = new Date();
		return Jwts.builder()
				.claims(claims)
				.issuedAt(now)
				.expiration(new Date(now.getTime() + validTime))
				.signWith(key)
				.compact();
	}

	public Claims getTokenClaims(String token) {
		return Jwts.parser()
				.verifyWith((javax.crypto.SecretKey)key)
				.build()
				.parseSignedClaims(token)
				.getPayload();
	}

	public boolean validateToken(String token) {
		try {
			Jwts.parser()
					.verifyWith((javax.crypto.SecretKey)key)
					.build()
					.parseSignedClaims(token);
			return true;
		} catch (SignatureException e) {
			log.warn("Invalid JWT Signature: {}", e.getMessage());
		} catch (MalformedJwtException e) {
			log.warn("Invalid JWT token: {}", e.getMessage());
		} catch (ExpiredJwtException e) {
			log.warn("Expired JWT token: {}", e.getMessage());
		} catch (UnsupportedJwtException e) {
			log.warn("Unsupported JWT token: {}", e.getMessage());
		} catch (IllegalArgumentException e) {
			log.warn("JWT claims string is empty: {}", e.getMessage());
		}
		return false;
	}

	public int getUserIdFromToken(String token) {
		try {
			return Integer.parseInt(getTokenClaims(token).getSubject());
		} catch (Exception e) {
			log.error("Failed to extract User ID from token.", e);
			throw new JwtException("Failed to process token claims.");
		}
	}

	public Long getRefreshTokenExpirationSeconds() {
		return REFRESH_TOKEN_VALID_TIME / 1000L;
	}
}

