package illusionists.serviceAdmin.security;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.TimeToLive;

import java.io.Serializable;
import java.util.concurrent.TimeUnit;

@Getter
@RedisHash("refreshToken")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RefreshToken implements Serializable {

	@Id private int userId;
	private String refreshToken;
	@TimeToLive(unit = TimeUnit.SECONDS) private Long expiration;

	@Builder
	public RefreshToken(int userId, String refreshToken, Long expiration) {
		this.userId = userId;
		this.refreshToken = refreshToken;
		this.expiration = expiration;
	}
}
