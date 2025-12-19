import 'package:yback_dashboard/features/dashboard/domain/entities/user_entity.dart';

abstract class DashboardRepository {
  Future<List<UserEntity>> fetchUsers(String targetUniversity);
}