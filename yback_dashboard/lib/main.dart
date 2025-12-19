import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/data/providers/auth_provider.dart';

void main() {
  // [필수] g.dart 파일 생성을 위해: dart run build_runner build -d
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: "Pretendard", // 폰트 있으면 적용 (없으면 생략)
      ),
      // [핵심] AuthGate 위젯을 홈으로 설정
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch하면 이제 AsyncValue<AdminSession?> 타입이 나옵니다.
    final authState = ref.watch(authProvider);

    // [상태 분기]
    return authState.when(
      // 1. 데이터 로딩 완료 시
      data: (session) {
        if (session != null) {
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
      // 2. 로딩 중일 때 (저장소 확인 중) -> 스플래시 화면
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      // 3. 에러 났을 때
      error: (err, stack) => Scaffold(
        body: Center(child: Text("초기화 오류: $err")),
      ),
    );
  }
}