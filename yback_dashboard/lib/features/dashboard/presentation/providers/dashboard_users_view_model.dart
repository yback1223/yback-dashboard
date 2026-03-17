import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yback_dashboard/core/network/dio_provider.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';

part 'dashboard_users_view_model.g.dart';

class DashboardUsersState {
  final List<UserEntity> users;
  final int totalElements;
  final int currentPage;
  final int pageSize;
  final bool isLoading;
  final String? errorMessage;
  final String searchKeyword;
  final String selectedServiceType;
  final List<String> availableServiceTypes;

  DashboardUsersState({
    this.users = const [],
    this.totalElements = 0,
    this.currentPage = 1,
    this.pageSize = 20,
    this.isLoading = true,
    this.errorMessage,
    this.searchKeyword = '',
    this.selectedServiceType = '전체',
    this.availableServiceTypes = const ['전체'],
  });

  DashboardUsersState copyWith({
    List<UserEntity>? users,
    int? totalElements,
    int? currentPage,
    int? pageSize,
    bool? isLoading,
    String? errorMessage,
    String? searchKeyword,
    String? selectedServiceType,
    List<String>? availableServiceTypes,
  }) {
    return DashboardUsersState(
      users: users ?? this.users,
      totalElements: totalElements ?? this.totalElements,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      availableServiceTypes: availableServiceTypes ?? this.availableServiceTypes,
    );
  }
}

@riverpod
class DashboardUsersViewModel extends _$DashboardUsersViewModel {
  @override
  DashboardUsersState build() {
    // build는 순수하게 상태만 반환한다. (Trigger는 UI의 initState가 담당)
    return DashboardUsersState();
  }

  Future<void> init() async {
    // 이미 데이터가 있으면 무시하여 불필요한 네트워크 비용을 아낀다.
    if (state.users.isNotEmpty) return;
    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final dio = ref.read(dioProvider);

    try {
      final Map<String, dynamic> queryParams = {
        'page': state.currentPage - 1,
        'size': state.pageSize,
      };
      
      if (state.searchKeyword.isNotEmpty) queryParams['searchName'] = state.searchKeyword;
      if (state.selectedServiceType != '전체') queryParams['serviceType'] = state.selectedServiceType;

      final response = await dio.get('/users/page', queryParameters: queryParams);

      final data = response.data;
      final List<dynamic> content = data['content'] ?? [];
      
      final users = content.map((json) => UserEntity.fromJson(json)).toList();
      final totalElements = data['totalElements'] ?? 0;

      // 현재 가져온 데이터에서 서비스 타입을 추출하여 필터 목록을 갱신한다.
      final currentTypes = users.map((u) => u.serviceType).toSet().toList();
      final updatedTypes = {...state.availableServiceTypes, ...currentTypes}.toList();

      state = state.copyWith(
        users: users,
        totalElements: totalElements,
        isLoading: false,
        availableServiceTypes: updatedTypes,
      );
    } catch (e) {
      // 401 에러 등이 발생하면 여기에 잡힌다.
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "데이터 로드 실패: $e"
      );
    }
  }

  void setServiceType(String type) {
    if (type == state.selectedServiceType) return;
    state = state.copyWith(selectedServiceType: type, currentPage: 1);
    fetchUsers();
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword, currentPage: 1);
    fetchUsers();
  }

  void setPage(int page) {
    if (page == state.currentPage) return;
    state = state.copyWith(currentPage: page);
    fetchUsers();
  }

  void setPageSize(int size) {
    if (size == state.pageSize) return;
    state = state.copyWith(pageSize: size, currentPage: 1);
    fetchUsers();
  }
}