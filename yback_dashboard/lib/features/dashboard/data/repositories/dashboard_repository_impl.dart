import 'package:dio/dio.dart';
import 'package:yback_dashboard/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:yback_dashboard/features/dashboard/domain/entities/user_entity.dart';
import 'package:yback_dashboard/features/dashboard/data/models/user_dto.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;

  // 생성자로 Dio 주입 받음
  DashboardRepositoryImpl(this._dio);

  @override
  Future<List<UserEntity>> fetchUsers(String targetUniversity) async {
    try {
      // GET /users?university=건국대학교
      final response = await _dio.get(
        '/users',
        queryParameters: {'university': targetUniversity},
      );

      // Dio는 response.data가 이미 List<dynamic> (JSON Array) 상태입니다.
      final List<dynamic> list = response.data;

      return list
          .map((json) => UserDto.fromJson(json).toEntity())
          .toList();
          
    } on DioException catch (e) {
      // 실제 배포 시에는 에러 로그를 남기거나 커스텀 에러로 변환
      throw Exception("데이터 로드 실패: ${e.message}");
    }
  }
}