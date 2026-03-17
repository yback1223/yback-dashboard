// dio_provider.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // 1. 기본 설정 (Base URL, 타임아웃 등)
  final options = BaseOptions(
    baseUrl: '/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);
  const storage = FlutterSecureStorage();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await storage.read(key: 'accessToken');
        if (accessToken != null) options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await storage.read(key: 'refreshToken');
            
            if (refreshToken != null) {
              try {
                // 👈 [수정] 기존 설정을 복사하여 refresh용 Dio 생성 (BaseURL 유실 방지)
                final refreshDio = Dio(BaseOptions(
                  baseUrl: e.requestOptions.baseUrl, // 기존 '/api' 유지
                  connectTimeout: const Duration(seconds: 5),
                  receiveTimeout: const Duration(seconds: 3),
                ));

                final refreshResponse = await refreshDio.post(
                  '/auth/refresh', // baseUrl이 /api이므로 경로 수정
                  data: {'refreshToken': refreshToken},
                );

                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];

                if (newAccessToken == null) throw Exception("New Token is Null");

                await storage.write(key: 'accessToken', value: newAccessToken);
                await storage.write(key: 'refreshToken', value: newRefreshToken);

                // 👈 [집행] dio.fetch 대신 명시적인 request 재호출
                final options = e.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryPath = options.path.isEmpty ? '/' : options.path;

                // fetch 대신 request를 사용하고, path가 null이 아닌지 강제 체크
                final response = await dio.request(
                  retryPath,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );

                return handler.resolve(response);
              } catch (error) {
                print("🚨 Refresh Token Error: $error");
                await storage.deleteAll();
                // 로그인 페이지로 이동하는 로직이 필요할 수 있음
                return handler.reject(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
  );

  return dio;
}