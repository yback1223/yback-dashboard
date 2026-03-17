// lib/features/admin/presentation/providers/admin_users_view_model.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yback_dashboard/core/network/dio_provider.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';
import 'admin_users_state.dart'; // 위에서 만든 상태 임포트

part 'admin_users_view_model.g.dart';

@riverpod
class AdminUsersViewModel extends _$AdminUsersViewModel {
  @override
  AdminUsersState build() {
    Future.microtask(() => init());
    return AdminUsersState();
  }

  Future<void> init() async {
    await _fetchAvailableGroups();
    await _fetchAvailableTypes();
    await fetchUsers();
  }

  Future<void> _fetchAvailableGroups() async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get('/service-groups');
      final List<dynamic> rawData = response.data as List<dynamic>? ?? [];
      final List<String> groups = <String>[
        '전체', 
        ...rawData.map((e) => e.toString()).toList()
      ];
      
      state = state.copyWith(availableGroups: groups);
    } catch (e) {
      // 👈 여기서 catch에 걸리지 않고 TypeError가 던져지면 앱이 죽는다.
      print("🚨 그룹 목록 로드 실패: $e");
    }
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final dio = ref.read(dioProvider);

    try {
      final Map<String, dynamic> queryParams = {
        'page': state.currentPage - 1,
        'size': state.pageSize,
      };

      if (state.searchKeyword.isNotEmpty) {
        queryParams['searchName'] = state.searchKeyword;
      }
      if (state.selectedGroup != '전체') {
        queryParams['serviceGroup'] = state.selectedGroup;
      }
      if (state.selectedType != '전체') {
        queryParams['serviceType'] = state.selectedType;
      }

      // 👈 [주의] 엔드포인트 앞에 '/'가 누락되지 않았는지 확인
      final response = await dio.get(
        '/users/page',
        queryParameters: queryParams,
      );
      final Map<String, dynamic> data = response.data; // 명시적 타입 지정

      final List<UserEntity> fetchedUsers = (data['content'] as List<dynamic>)
          .map<UserEntity>((e) => UserEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        users: fetchedUsers,
        // 🚨 [집행] 괄호를 하나 더 써서 명시적으로 int로 변환하고 넘겨라. 
        // 데이터가 dynamic 상태로 넘어가면 kI와 h6 충돌이 여기서 터진다.
        totalElements: (UserEntity.toInt(data['totalElements'])), 
        isLoading: false,
        selectedIds: <int>{},
        editedUsers: <int, UserEntity>{},
      );

    } catch (e, stack) {
      // 👈 [집행] 에러 발생 시 상세 로그 출력
      print("🚨 [API ERROR] 데이터 로드 실패: $e");
      print("📍 StackTrace: $stack");
      state = state.copyWith(isLoading: false, errorMessage: "데이터 로드 실패: $e");
    }
  }

  // 상태 변경 메서드들
  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  // 🚨 [집행] 조회 버튼이나 엔터를 눌렀을 때만 실행
  void executeSearch() {
    state = state.copyWith(currentPage: 1); // 검색 시 1페이지부터
    fetchUsers();
  }

  Future<void> setFilterGroup(String group) async {
    // 그룹이 바뀌면 타입은 무조건 '전체'로 초기화한다.
    state = state.copyWith(selectedGroup: group, selectedType: '전체', currentPage: 1);
    
    // 선택된 그룹에 맞는 타입 목록을 다시 로드한다.
    await _fetchAvailableTypes();
    
    // 주의: 여기서 fetchUsers()를 바로 호출하지 않는다. (검색 버튼 클릭 시 호출)
  }

  // 2. 타입 목록 로드 (그룹 필터 상태를 기반으로 API 호출)
  Future<void> _fetchAvailableTypes() async {
    final dio = ref.read(dioProvider);
    try {
      // 🚨 [집행] '전체'일 경우 queryParameters를 아예 비워서 보낸다.
      // 백엔드 컨트롤러 스펙상 groupNames가 없으면(null) 전체 합집합을 반환하기 때문.
      final Map<String, dynamic>? queryParams = (state.selectedGroup == '전체') 
          ? null 
          : {'groupNames': [state.selectedGroup]};

      final response = await dio.get(
        '/service-types', // 👈 엔드포인트 경로 재확인
        queryParameters: queryParams,
      );
      
      final List<dynamic> rawData = response.data as List<dynamic>? ?? [];
      
      // 서버에서 받아온 타입 목록에 '전체' 옵션을 최상단에 추가
      final List<String> types = ['전체', ...rawData.map((e) => e['name'].toString())];
      
      state = state.copyWith(availableTypes: types);
      
      // 💡 만약 현재 선택된 타입이 새로 불러온 목록에 없다면 '전체'로 리셋
      if (!types.contains(state.selectedType)) {
        state = state.copyWith(selectedType: '전체');
      }
    } catch (e) {
      print("🚨 서비스 타입 합집합 로드 실패: $e");
    }
  }

  // 3. 타입 변경 (단순 상태 변경)
  void setFilterType(String type) {
    state = state.copyWith(selectedType: type, currentPage: 1);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
    fetchUsers();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    fetchUsers();
  }

  // 수정/삭제 로직 (기존 유지)
  void toggleSelection(int id) {
    final newSelected = Set<int>.from(state.selectedIds);
    if (newSelected.contains(id))
      newSelected.remove(id);
    else
      newSelected.add(id);
    state = state.copyWith(selectedIds: newSelected);
  }

  // ✅ [집행]
  void toggleAllSelection(bool isSelected) {
    if (isSelected) {
      final Set<int> allIds = state.users.map<int>((e) => e.id).toSet();
      state = state.copyWith(selectedIds: allIds);
    } else {
      state = state.copyWith(selectedIds: <int>{}); 
    }
  }

  void updateUserField(int id, String field, dynamic newValue) {
    final originalUser = state.users.firstWhere((u) => u.id == id);
    var userToEdit = state.editedUsers[id] ?? originalUser;

    if (field == 'name') userToEdit = userToEdit.copyWith(name: newValue);
    else if (field == 'serviceType') userToEdit = userToEdit.copyWith(serviceType: newValue);
    else if (field == 'emailId') userToEdit = userToEdit.copyWith(emailId: newValue);
    else if (field == 'startDate') userToEdit = userToEdit.copyWith(startDate: newValue);
    else if (field == 'endDate') {
      userToEdit = userToEdit.copyWith(endDate: newValue);
      // 💡 [심화] 종료일이 바뀌면 dDay를 임시로 재계산해서 UI에 반영
      final end = DateTime.parse(newValue);
      final now = DateTime.now();
      final diff = end.difference(DateTime(now.year, now.month, now.day)).inDays;
      userToEdit = userToEdit.copyWith(dDay: diff);
    }

    final newEditedUsers = Map<int, UserEntity>.from(state.editedUsers);
    newEditedUsers[id] = userToEdit;
    state = state.copyWith(editedUsers: newEditedUsers);
  }

  // 일괄 삭제 집행
  Future<void> batchDelete() async {
    if (state.selectedIds.isEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    final dio = ref.read(dioProvider);

    try {
      await dio.delete(
        '/users/batch',
        data: {'ids': state.selectedIds.toList()},
      );

      // 삭제 성공 후 상태 초기화 및 목록 재조회
      state = state.copyWith(selectedIds: <int>{});
      await fetchUsers();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "삭제 실패: $e");
    }
  }

  // 일괄 수정 집행
  Future<void> batchUpdate() async {
    if (state.editedUsers.isEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    final dio = ref.read(dioProvider);

    try {
      final updateData = state.editedUsers.values
          .map((u) => u.toJson())
          .toList();
      await dio.put('/users/batch', data: updateData);

      state = state.copyWith(editedUsers: <int, UserEntity>{});
      await fetchUsers();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "수정 실패: $e");
    }
  }
}
