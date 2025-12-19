package illusionists.serviceAdmin.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ServiceGroupCreateRequest {

    @NotBlank(message = "그룹명은 필수입니다.")
    private String name;
}