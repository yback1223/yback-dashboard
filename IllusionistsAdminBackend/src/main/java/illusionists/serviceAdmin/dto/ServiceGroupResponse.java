package illusionists.serviceAdmin.dto;

import illusionists.serviceAdmin.entity.ServiceGroup;
import lombok.Getter;

@Getter
public class ServiceGroupResponse {
    private int id;
    private String name;

    public ServiceGroupResponse(ServiceGroup entity) {
        this.id = entity.getId();
        this.name = entity.getName();
    }
}