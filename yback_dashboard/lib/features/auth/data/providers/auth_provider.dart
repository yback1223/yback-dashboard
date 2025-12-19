import 'dart:convert'; // JSON 변환용
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yback_dashboard/core/network/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'auth_provider.g.dart';

const storage = FlutterSecureStorage();

class AdminSession {
  final String username;
  final String university;
  final String accessToken;
  final String refreshToken;
  final String userRole;  

  AdminSession({required this.username, required this.university, required this.accessToken, required this.refreshToken, required this.userRole});

  // [추가] 객체를 JSON 문자열로 변환 (직렬화)
  Map<String, dynamic> toJson() => {
        'username': username,
        'university': university,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'userRole': userRole,
      };

  // [추가] JSON 문자열을 객체로 변환 (역직렬화)
  factory AdminSession.fromJson(Map<String, dynamic> json) {
    return AdminSession(
      username: json['username'],
      university: json['university'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'], 
      userRole: json['userRole'],
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  // 키 값 상수
  static const _storageKey = 'admin_session';

  @override
  Future<AdminSession?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    
    if (jsonString != null) {
      try {
        return AdminSession.fromJson(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> login(String id, String password) async {
    
    // 1. Dio 객체 가져오기 (DI)
    final dio = ref.read(dioProvider);

    try {
      final response = await dio.post('/login', data: {
        'id': id,
        'password': password,
      });

      // 3. 성공 처리 (Dio는 2xx가 아니면 에러를 던지므로 여기는 무조건 성공)
      final data = response.data; // 이미 Map 상태임
      await storage.write(key: 'accessToken', value: data['accessToken']);
      await storage.write(key: 'refreshToken', value: data['refreshToken']);
      final session = AdminSession(
        username: data['username'],
        university: data['university'], 
        userRole: data['userRole'],
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );

      // 4. 상태 업데이트 및 저장 (기존 로직 동일)
      state = AsyncData(session);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(session.toJson()));

    } on DioException catch (e) {
      // 4. 에러 처리 (Dio 전용 예외)
      if (e.response != null) {
         // 서버가 에러 응답을 보낸 경우 (400, 401, 500 등)
         throw Exception("로그인 실패: ${e.response?.data['message'] ?? '알 수 없는 오류'}");
      } else {
         // 연결 실패 등
         throw Exception("서버 연결 실패: 인터넷 연결을 확인하세요.");
      }
    }
  }

  // [로그아웃]
  Future<void> logout() async {
    state = const AsyncData(null); // 메모리 초기화
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey); // 저장소 삭제
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }
}