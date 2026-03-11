package illusionists.serviceAdmin.dto;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotEmpty;

@Getter
@NoArgsConstructor
public class AdminUserConnectRequest {
    @NotEmpty(message = "그룹명은 최소 하나 이상 선택해야 합니다.")
    private List<String> groupNames;
}
