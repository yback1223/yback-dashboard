import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';

abstract class DashboardRepository {
  Future<List<UserEntity>> fetchUsers(String targetServiceGroupName);
}