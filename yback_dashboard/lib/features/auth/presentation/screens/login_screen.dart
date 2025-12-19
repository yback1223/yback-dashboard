import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yback_dashboard/features/auth/data/providers/auth_provider.dart';
import 'package:yback_dashboard/core/constants/app_assets.dart';
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withValues(alpha: 0.95),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAssets.illusionistsLogo1, fit: BoxFit.contain),
                    const SizedBox(height: 40),

                    // ID 입력
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: "ID",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // PW 입력
                    TextField(
                      controller: _pwController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      // [엔터 처리] 유효성 검사 로직이 포함된 _handleLogin 호출
                      onSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        labelText: "비밀번호",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("로그인", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // [핵심 로직] 로그인 처리 함수
  Future<void> _handleLogin() async {
    // 1. 입력값 가져오기 (공백 제거)
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    // 2. [Validation] 빈 값 체크
    if (id.isEmpty) {
      _showWarning("아이디를 입력해주세요.");
      return; // 로직 중단
    }
    if (pw.isEmpty) {
      _showWarning("비밀번호를 입력해주세요.");
      return; // 로직 중단
    }

    // 3. 로그인 시도
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).login(id, pw);
      // 성공 시: main.dart의 AuthGate가 감지하고 화면 전환
    } catch (e) {
      // 4. [Exception] 로그인 실패 처리
      // "Exception: " 글자 떼고 깔끔한 메시지만 보여주기
      final errorMessage = e.toString().replaceAll("Exception: ", "");
      _showWarning(errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [UI Helper] 경고 메시지(SnackBar) 보여주는 함수
  void _showWarning(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).clearSnackBars(); // 이전 메시지 닫기
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.redAccent, // 경고는 빨간색이 국룰
        behavior: SnackBarBehavior.floating, // 화면 바닥에서 살짝 띄우기 (웹에서 보기 좋음)
        width: 400, // 너무 길지 않게 고정
        duration: const Duration(seconds: 2),
      ),
    );
  }
}