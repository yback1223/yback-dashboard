import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';

part 'admin_users_state.freezed.dart';

@freezed
abstract class AdminUsersState with _$AdminUsersState {
  const factory AdminUsersState({
    @Default([]) List<UserEntity> users,
    @Default(0) int totalElements,
    @Default(1) int currentPage,
    @Default(20) int pageSize,
    @Default(<int>{}) Set<int> selectedIds, // 👈 <int> 명시
    @Default(<int, UserEntity>{}) Map<int, UserEntity> editedUsers, // 👈 타입 명시
    @Default(true) bool isLoading,
    String? errorMessage,
    @Default('') String searchKeyword,
    @Default('전체') String selectedGroup,
    @Default('전체') String selectedType,
    @Default(['전체']) List<String> availableGroups,
    @Default(['전체']) List<String> availableTypes,
  }) = _AdminUsersState;
}