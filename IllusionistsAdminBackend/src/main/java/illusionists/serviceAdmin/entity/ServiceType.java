// ServiceType.java

package illusionists.serviceAdmin.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "\"service_type\"")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ServiceType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 30, unique = true)
    private String name;

    // 🚨 [추가] 이 타입이 어느 그룹들에 속해있는지 역방향 조회 가능하게 설정
    @ManyToMany(mappedBy = "serviceTypes")
    @Builder.Default
    private List<ServiceGroup> serviceGroups = new ArrayList<>();
}