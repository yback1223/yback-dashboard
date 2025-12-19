package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.dto.UserResponseDto;
import illusionists.serviceAdmin.entity.AdminUser;
import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.entity.User;
import illusionists.serviceAdmin.repository.AdminUserRepository;
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import illusionists.serviceAdmin.repository.UserRepository;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

	private final UserRepository userRepository;
	private final ServiceGroupRepository serviceGroupRepository;
	private final AdminUserRepository adminUserRepository;

	public List<UserResponseDto> getUsersByAdminId(int adminId) {

		AdminUser admin = adminUserRepository.findById(adminId)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 관리자입니다."));

		String universityName = admin.getGroup().getName();

		return userRepository.findAllByUniversity(universityName)
				.stream()
				.map(UserResponseDto::from)
				.toList();
	}

	@Transactional
	public void uploadUserExcel(MultipartFile file, String groupInput) throws IOException {
		// 1. 업로더(관리자)의 학교 정보 가져오기
		ServiceGroup group = serviceGroupRepository.findByName(groupInput)
				.orElseThrow(() -> new IllegalArgumentException("존재하지 않는 그룹입니다: " + groupInput));

		List<User> userList = new ArrayList<>();

		// 2. 엑셀 파일 읽기
		try (InputStream is = file.getInputStream();
		     Workbook workbook = new XSSFWorkbook(is)) {

			Sheet sheet = workbook.getSheetAt(0); // 첫 번째 시트

			// 3. 행 반복 (헤더인 0번째 로우는 건너뛰고 1부터 시작)
			for (int i = 1; i <= sheet.getLastRowNum(); i++) {
				Row row = sheet.getRow(i);
				if (row == null) continue;

				// 엑셀 컬럼 순서: 이름(0), 서비스(1), ID(2), PW(3), 시작(4), 구독기한(5), 비고(6)

				// 이름
				String name = getCellValue(row.getCell(0));
				// 서비스 타입
				String serviceType = getCellValue(row.getCell(1));
				// 이메일 ID
				String emailId = getCellValue(row.getCell(2));
				// 비밀번호 (암호화 필요)
				String rawPassword = getCellValue(row.getCell(3));

				// 시작 날짜 처리 ("251219" -> 2025-12-19)
				String startDateStr = getCellValue(row.getCell(4));
				LocalDateTime startDate = parseDate(startDateStr);

				// 종료 날짜 처리 (구독기한 컬럼 숫자를 읽어서 더함, 없으면 기본 2개월)
				String durationStr = getCellValue(row.getCell(5));
				int monthsToAdd = 2; // 기본값
				try {
					if (durationStr != null && !durationStr.isBlank()) {
						// "2" 또는 "2.0" 등의 숫자만 파싱
						double d = Double.parseDouble(durationStr);
						monthsToAdd = (int) d;
					}
				} catch (NumberFormatException ignored) {

				}

				LocalDateTime endDate = startDate.plusMonths(monthsToAdd)
						.withHour(23).withMinute(59).withSecond(59); // 종료일은 보통 하루 끝

				// 비고
				String etc = getCellValue(row.getCell(6));

				// 엔티티 생성
				User user = User.builder()
						.name(name)
						.group(group) // 관리자의 학교 그룹 자동 할당
						.serviceType(serviceType)
						.emailId(emailId)
						.password(rawPassword)
						.startDate(startDate)
						.endDate(endDate)
						.etc(etc)
						.createdAt(LocalDateTime.now())
						.updatedAt(LocalDateTime.now())
						.build();

				userList.add(user);
			}
		}

		// 4. DB 일괄 저장
		userRepository.saveAll(userList);
	}

	// 셀 타입에 상관없이 문자열로 가져오는 유틸 메서드
	private String getCellValue(Cell cell) {
		if (cell == null) return "";
		return switch (cell.getCellType()) {
			case STRING -> cell.getStringCellValue();
			case NUMERIC -> {
				// 날짜나 정수형 숫자 처리
				if (DateUtil.isCellDateFormatted(cell)) {
					yield cell.getLocalDateTimeCellValue().format(DateTimeFormatter.ofPattern("yyMMdd"));
				}
				yield String.valueOf((int) cell.getNumericCellValue());
			}
			case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
			case FORMULA -> cell.getCellFormula();
			default -> "";
		};
	}

	// "yyMMdd" 문자열을 LocalDateTime으로 변환
	private LocalDateTime parseDate(String dateStr) {
		if (dateStr == null || dateStr.isBlank()) {
			return LocalDateTime.now(); // 값이 없으면 현재 시간 (예외처리 정책에 따라 변경 가능)
		}
		try {
			// "251219" -> LocalDate
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd");
			LocalDate date = LocalDate.parse(dateStr, formatter);
			return date.atStartOfDay(); // 00:00:00으로 설정
		} catch (Exception e) {
			throw new IllegalArgumentException("날짜 형식이 올바르지 않습니다 (yyMMdd): " + dateStr);
		}
	}

	@Transactional
	public void deleteAllUsers() {
		// deleteAllInBatch: 한 방 쿼리로 테이블을 비워버림 (성능 우수)
		userRepository.deleteAllInBatch();
	}
}