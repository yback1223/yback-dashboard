import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yback_dashboard/features/dashboard/domain/entities/user_entity.dart';
import 'package:yback_dashboard/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
// [중요] AuthProvider가 있는 경로를 정확히 임포트해야 함
import 'package:yback_dashboard/features/auth/data/providers/auth_provider.dart'; 

part 'dashboard_view_model.g.dart';

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  
  @override
  Future<List<UserEntity>> build() async {
    // [수정] AsyncValue에서 값을 꺼냅니다.
    final authState = ref.watch(authProvider);
    
    // 아직 로딩 중이거나 데이터가 없으면 빈 리스트
    if (authState.value == null) {
      return []; 
    }
    
    final session = authState.value!; // 세션 확정

    final repository = ref.watch(dashboardRepositoryProvider);
    return await repository.fetchUsers(session.university);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // [수정] read도 마찬가지로 .value로 접근
      final session = ref.read(authProvider).value;
      
      if (session == null) return [];

      final repository = ref.read(dashboardRepositoryProvider);
      return await repository.fetchUsers(session.university);
    });
  }
}