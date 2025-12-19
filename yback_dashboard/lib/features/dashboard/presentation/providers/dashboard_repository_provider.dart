import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yback_dashboard/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:yback_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:yback_dashboard/core/network/dio_provider.dart';

part 'dashboard_repository_provider.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepositoryImpl(dio);
}