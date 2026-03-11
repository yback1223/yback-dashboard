// AdminUser.java

package illusionists.serviceAdmin.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import java.util.List;
import java.util.ArrayList;
import lombok.Builder;

@Entity
@Table(name = "\"admin_user\"")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
@EntityListeners(AuditingEntityListener.class)
public class AdminUser extends Base {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "admin_user_service_groups",
        joinColumns = @JoinColumn(name = "admin_user_id"),
        inverseJoinColumns = @JoinColumn(name = "service_group_id")
    )
	@Builder.Default // [추가] 빌더 사용 시 초기값 빈 리스트 보장
    private List<ServiceGroup> groups = new ArrayList<>();

	@Column(nullable = false)
	private String username;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private UserRole role;

	@Column(nullable = false, length = 50)
	private String loginId;

	@Column(nullable = false)
	private String password;
}
