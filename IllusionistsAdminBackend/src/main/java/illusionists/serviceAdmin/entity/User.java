package illusionists.serviceAdmin.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.SuperBuilder;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

@Entity
@Table(name = "\"user\"")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
@EntityListeners(AuditingEntityListener.class)
public class User extends Base {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	@Column(nullable = false, length = 30)
	private String name;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "service_group_id", nullable = false) // DB 컬럼명 지정 (Foreign Key)
	private ServiceGroup group;

	@Column(nullable = false, length = 30)
	private String serviceType;

	@Column(nullable = false, length = 50)
	private String emailId;

	@Column(nullable = true)
	private String password;

	@Column(nullable = false)
	private LocalDateTime startDate;

	@Column(nullable = false)
	private LocalDateTime endDate;

	@Column()
	private String etc;
}