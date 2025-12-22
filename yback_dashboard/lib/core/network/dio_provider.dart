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
              final refreshDio = Dio();
              final refreshResponse = await refreshDio.post(
                '/api/auth/refresh', // 백엔드 갱신 주소
                data: {'refreshToken': refreshToken},
              );

              final newAccessToken = refreshResponse.data['accessToken'];
              final newRefreshToken = refreshResponse.data['refreshToken'];

              await storage.write(key: 'accessToken', value: newAccessToken);
              await storage.write(key: 'refreshToken', value: newRefreshToken);

              final clonedRequest = e.requestOptions;

              clonedRequest.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(clonedRequest);
              return handler.resolve(retryResponse);
            } catch (error) {
              await storage.delete(key: 'accessToken');
              await storage.delete(key: 'refreshToken');
              await storage.deleteAll();
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