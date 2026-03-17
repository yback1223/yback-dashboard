// UserService.java

package illusionists.serviceAdmin.service;

import illusionists.serviceAdmin.dto.UserResponseDto;
import illusionists.serviceAdmin.dto.UserUpdateRequestDto;
import illusionists.serviceAdmin.entity.AdminUser;
import illusionists.serviceAdmin.entity.ServiceGroup;
import illusionists.serviceAdmin.entity.ServiceType;
import illusionists.serviceAdmin.entity.User;
import illusionists.serviceAdmin.repository.AdminUserRepository;
import illusionists.serviceAdmin.repository.ServiceGroupRepository;
import illusionists.serviceAdmin.repository.ServiceTypeRepository;
import illusionists.serviceAdmin.repository.UserRepository;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.stream.Collectors;
import java.util.*;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;
    private final ServiceGroupRepository serviceGroupRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final AdminUserRepository adminUserRepository;
    private final ServiceGroupService serviceGroupService;
    private final JdbcTemplate jdbcTemplate;


	
	public Page<UserResponseDto> getUsersPageByAdminId(
            Integer adminId, 
            String searchName, 
            String serviceType, 
            String serviceGroup, // 👈 프론트에서 넘긴 값
            Pageable pageable) {
        
        AdminUser admin = adminUserRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 관리자입니다."));

        // "전체"일 경우 null로 처리하여 쿼리에서 무시되도록 함
        String filterType = ("전체".equals(serviceType)) ? null : serviceType;
        String filterGroup = ("전체".equals(serviceGroup) || serviceGroup == null) ? null : serviceGroup;
        
        Page<User> usersPage;

        if ("ILLUSIONIST".equals(admin.getRole().name())) {
            // [수정] filterGroup(serviceGroup)을 쿼리에 전달한다.
            usersPage = userRepository.findAllByFilters(searchName, filterType, filterGroup, pageable);
        } 
        else {
            List<ServiceGroup> groups = admin.getGroups();
            if (groups == null || groups.isEmpty()) return Page.empty(pageable);

            // 일반 관리자가 특정 그룹을 선택했다면, 그 그룹이 본인 소속인지 검증 후 필터링하는 것이 안전함
            // 여기서는 단순화하여 본인 소속 그룹 리스트와 선택한 그룹명을 동시에 넘겨 처리 가능
            usersPage = userRepository.findByGroupsAndFilters(groups, searchName, filterType, filterGroup, pageable);
        }

        return usersPage.map(UserResponseDto::from);
    }

    @Transactional
    public void updateUsersBatch(List<UserUpdateRequestDto> updateRequests) {
        if (updateRequests.isEmpty()) return;

        // 모든 서비스 타입을 한 번에 캐싱 (N+1 방지)
        Map<String, Integer> typeMap = serviceTypeRepository.findAll().stream()
                .collect(Collectors.toMap(ServiceType::getName, ServiceType::getId));

        String sql = "UPDATE \"user\" SET name = ?, service_type_id = ?, email_id = ?, " +
                     "password = ?, start_date = ?, end_date = ?, updated_at = NOW() " +
                     "WHERE id = ?";

        jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                UserUpdateRequestDto req = updateRequests.get(i);
                Integer typeId = typeMap.get(req.serviceType());
                if (typeId == null) throw new IllegalArgumentException("타입 없음: " + req.serviceType());

                ps.setString(1, req.name());
                ps.setInt(2, typeId);
                ps.setString(3, req.emailId());
                ps.setString(4, req.password());
                ps.setTimestamp(5, Timestamp.valueOf(req.startDate()));
                ps.setTimestamp(6, Timestamp.valueOf(req.endDate()));
                ps.setInt(7, req.id());
            }
            @Override
            public int getBatchSize() { return updateRequests.size(); }
        });
    }

    @Transactional
    public void uploadUserExcel(MultipartFile file, String groupInput, MultipartFile image) throws IOException {
        // 1. 서비스 그룹 조회 및 이미지 업데이트 로직
        ServiceGroup group = serviceGroupRepository.findByName(groupInput).orElse(null);
        
        // UserService.java 수정부
        String imageUrl = null; 

        if (image != null && !image.isEmpty()) {
            // 💡 저장 로직 실행
            String fileName = serviceGroupService.saveImage(image);
            // 명시적으로 null이 아님을 보장하는 시점에 값을 할당
            imageUrl = "/assets/images/" + fileName + "?v=" + System.currentTimeMillis();
        }

        // 이후 로직에서 imageUrl을 사용할 때 @NonNull 제약이 있다면:
        String finalUrl = (imageUrl != null) ? imageUrl : "default_image_url";

        if (group == null) {
            // 그룹이 없으면 신규 생성
            group = serviceGroupRepository.save(
                ServiceGroup.builder()
                    .name(groupInput)
                    .imageUrl(finalUrl)
                    .build()
            );
        } else if (imageUrl != null) {
            // 💡 [개선] 이미 존재하는 그룹인데 새로운 이미지가 들어왔다면 업데이트
            // (Entity에 updateImageUrl 메서드를 추가하거나 직접 필드 변경 권장)
            // group.updateImageUrl(imageUrl); 
        }

        // 2. [캐싱] 중복 체크 및 N+1 방지를 위한 데이터 로드
        Map<String, User> existingUserMap = userRepository.findAllByGroup(group).stream()
                .collect(Collectors.toMap(User::getEmailId, u -> u, (e, r) -> e));

        Map<String, ServiceType> allServiceTypes = serviceTypeRepository.findAll().stream()
                .collect(Collectors.toMap(ServiceType::getName, t -> t, (e, r) -> e));

        Set<String> existingTypeNamesInGroup = group.getServiceTypes().stream()
                .map(ServiceType::getName)
                .collect(Collectors.toSet());

        List<User> newUsers = new ArrayList<>();

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0); 

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                String name = getCellValue(row.getCell(0)).trim();
                if (name.isEmpty()) continue;

                String typeName = getCellValue(row.getCell(1)).trim();
                String emailId = getCellValue(row.getCell(2)).trim();
                String rawPassword = getCellValue(row.getCell(3)).trim();
                
                // 날짜 파싱 (예외 처리 강화)
                LocalDateTime startDate = parseDate(getCellValue(row.getCell(4)));
                LocalDateTime endDate = startDate.plusMonths(2).withHour(23).withMinute(59); 

                // 서비스 타입 처리
                ServiceType serviceType = allServiceTypes.computeIfAbsent(typeName, nameKey -> {
                    return serviceTypeRepository.save(ServiceType.builder().name(nameKey).build());
                });

                if (!existingTypeNamesInGroup.contains(typeName)) {
                    group.getServiceTypes().add(serviceType);
                    existingTypeNamesInGroup.add(typeName);
                }

                // Upsert 로직
                User targetUser = existingUserMap.get(emailId);
                if (targetUser != null) {
                    targetUser.updateProfile(name, serviceType, emailId, rawPassword, startDate, endDate);
                } else {
                    User newUser = User.builder()
                            .name(name)
                            .group(group)
                            .serviceType(serviceType)
                            .emailId(emailId)
                            .password(rawPassword)
                            .startDate(startDate)
                            .endDate(endDate)
                            .build();
                    newUsers.add(newUser);
                    existingUserMap.put(emailId, newUser);
                }
            }
        }
        
        if (!newUsers.isEmpty()) {
            userRepository.saveAll(newUsers);
        }
    }


    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> {
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

    private LocalDateTime parseDate(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return LocalDateTime.now(); 
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd");
            return LocalDate.parse(dateStr, formatter).atStartOfDay(); 
        } catch (Exception e) {
            throw new IllegalArgumentException("날짜 형식이 올바르지 않습니다 (yyMMdd): " + dateStr);
        }
    }

    @Transactional
    public void deleteAllUsers() {
        userRepository.deleteAllInBatch();
    }

    @Transactional
    public void deleteUsersBatch(List<Integer> ids) {
        userRepository.deleteAllById(ids);
    }

    @Transactional
    public void deleteUsersByFilter(String groupName, String serviceType) {
        // 💡 프론트에서 넘어온 "전체"를 null로 정화 (Sanitizing)
        String filterGroup = "전체".equals(groupName) ? null : groupName;
        String filterType = "전체".equals(serviceType) ? null : serviceType;

        // 🚨 쿼리 한 방으로 조건에 맞는 데이터 말살 (JdbcTemplate보다 효율적인 JPQL 벌크 삭제)
        userRepository.deleteByFilter(filterGroup, filterType);
    }
}