package illusionists.serviceAdmin.dto;

import illusionists.serviceAdmin.entity.User;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public record UserResponseDto(
		int id,
		String name,
		String serviceType,
		String emailId,
		String password,
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

		if (percent < 0.0) percent = 0.0;
		if (percent > 1.0) percent = 1.0;

		return new UserResponseDto(
				user.getId(),
				user.getName(),
				user.getServiceType(),
				user.getEmailId(),
				user.getPassword(),
				user.getStartDate(),
				user.getEndDate(),
				(int) ChronoUnit.DAYS.between(now, user.getEndDate()),
				percent
		);
	}
}