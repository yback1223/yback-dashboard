package illusionists.serviceAdmin.dto;

import illusionists.serviceAdmin.entity.User;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public record UserResponseDto(
        int id,
        String name,
        String serviceType, // 👈 프론트엔드에는 여전히 "A형" 같은 문자열로 전달
        String emailId,
        String password,
        String role,
        LocalDateTime startDate,
        LocalDateTime endDate,
        int dDay,
        double dDayPercent
) {
    public static UserResponseDto from(User user) {
        LocalDateTime now = LocalDateTime.now();

        long totalDays = ChronoUnit.DAYS.between(user.getStartDate(), user.getEndDate());
        long remainingDays = ChronoUnit.DAYS.between(now, user.getEndDate());
        double percent = (totalDays > 0) ? (double) remainingDays / totalDays : 0.0;

        percent = Math.max(0.0, Math.min(1.0, percent));

        // 🚨 [집행] user.getServiceType()은 객체이므로 .getName()으로 문자열을 추출한다.
        String typeName = (user.getServiceType() != null) ? user.getServiceType().getName() : "미지정";
        String userRole = "USER"; 

        return new UserResponseDto(
                user.getId(),
                user.getName(),
                typeName, // 👈 여기서 String 타입을 맞춰줌으로써 에러 해결
                user.getEmailId(),
                user.getPassword(),
                userRole,
                user.getStartDate(),
                user.getEndDate(),
                (int) remainingDays,
                percent
        );
    }
}