// User.java

package illusionists.serviceAdmin.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.SuperBuilder;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

@Entity
@Table(
    name = "\"user\"",
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uq_group_email",
            columnNames = {"service_group_id", "email_id"} // DB 컬럼명 기준
        )
    }
)@Getter
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
	@JoinColumn(name = "service_group_id", nullable = false)
	private ServiceGroup group;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "service_type_id", nullable = false)
	private ServiceType serviceType;

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

	public void updateProfile(
		String name,
		ServiceType serviceType,
		String emailId,
		String password,
		LocalDateTime startDate,
		LocalDateTime endDate
	) {
        this.name = name;
        this.serviceType = serviceType;
        this.emailId = emailId;
		this.password = password;
        this.startDate = startDate;
        this.endDate = endDate;
    }
}