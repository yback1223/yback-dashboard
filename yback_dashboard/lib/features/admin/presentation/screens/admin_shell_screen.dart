// lib/features/admin/presentation/screens/admin_shell_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yback_dashboard/features/admin/presentation/widgets/admin_side_nav.dart';
import 'package:yback_dashboard/features/auth/data/providers/auth_provider.dart';
import 'package:yback_dashboard/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:yback_dashboard/features/admin/presentation/screens/excel_upload_screen.dart';

class AdminShellScreen extends ConsumerStatefulWidget {
  const AdminShellScreen({super.key});

  @override
  ConsumerState<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends ConsumerState<AdminShellScreen> {
  int _selectedIndex = 0;
  
  final List<String> _pageTitles = [
    "서비스 그룹 별 회원 종합 관리",
    "서비스 그룹 관리",
    "엑셀 데이터 연동",
    "시스템 로그 분석"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(authProvider).value;
      if (session == null || session.userRole != 'ILLUSIONIST') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("접근 권한이 없습니다. 마스터 관리자만 출입 가능합니다."), backgroundColor: Colors.red),
        );
        Navigator.of(context).pop(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      
      // 1. 상단 앱바 (이제 무조건 햄버거 버튼이 자동으로 생성됨)
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // leading 속성을 지웠으므로 플러터가 알아서 햄버거 버튼을 달아준다.
      ),
      
      // 2. 햄버거 메뉴를 누르면 나올 서랍 (앱바를 덮어버리는 형태)
      drawer: AdminSideNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onBackToDashboard: () {
          // 1. 열려 있는 사이드바(Drawer)를 먼저 닫는다.
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // Drawer 닫기
          }
          
          // 2. 관리자 페이지 자체를 닫고 이전 화면(Dashboard)으로 돌아간다.
          Navigator.of(context).pop(); 
        },
      ),

      // 3. 본문 레이아웃 (더 이상 Row가 필요 없음)
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const AdminUsersScreen(), // 회원 관리 페이지
          _buildPlaceholderScreen("여기에 그룹 생성, 이미지 업로드 UI가 들어갈 거다."),
          const ExcelUploadScreen(), // 엑셀 업로드 페이지
          _buildPlaceholderScreen("로그 차트 및 데이터 테이블 영역"),
        ],
      ),
    );
  }

  Widget _buildPlaceholderScreen(String description) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}