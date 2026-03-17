// ServiceGroup.java

package illusionists.serviceAdmin.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "\"service_group\"")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class ServiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = true)
	@Builder.Default
    private String imageUrl = null;

    // 🚨 [집행] 서비스 그룹과 타입 간의 다대다 매핑 테이블 정의
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "service_group_mapping", // DBML에서 정의한 테이블 이름
        joinColumns = @JoinColumn(name = "service_group_id"),
        inverseJoinColumns = @JoinColumn(name = "service_type_id")
    )
    @Builder.Default
    private List<ServiceType> serviceTypes = new ArrayList<>();
}