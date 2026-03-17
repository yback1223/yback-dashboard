// UserUpdateRequestDto.java

package illusionists.serviceAdmin.dto;

import java.time.LocalDateTime;

public record UserUpdateRequestDto(
    int id,               // 👈 수정을 위해 ID 필수
    String name,
    String serviceType,    // 👈 String serviceType 대신 ID로 변경
    String emailId,
    String password,
    LocalDateTime startDate,
    LocalDateTime endDate
) {
    // 💡 팁: 프론트엔드에서 날짜를 String으로 보낸다면 
    // 컨트롤러에서 @DateTimeFormat을 쓰거나 
    // 여기서 타입을 String으로 바꾸고 Service에서 파싱해야 한다.
}