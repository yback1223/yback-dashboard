// lib/features/admin/presentation/widgets/admin_side_nav.dart

import 'package:flutter/material.dart';

class AdminSideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onBackToDashboard;

  const AdminSideNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    // Drawer 위젯으로 감싸서 표준 사이드바 규격을 따른다
    return Drawer(
      backgroundColor: Colors.indigo.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 헤더 영역 (타이틀 + 닫기 버튼)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Master Admin",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                // 👇 [추가] 네가 요구한 우측 상단 닫기 버튼
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () {
                    Scaffold.of(context).closeDrawer();
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          
          // 2. 메뉴 리스트
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(context, icon: Icons.people, title: "서비스 그룹 별 회원 관리", index: 0),
                _buildNavItem(context, icon: Icons.category, title: "서비스 그룹 관리", index: 1),
                _buildNavItem(context, icon: Icons.upload_file, title: "엑셀 업로드", index: 2),
                _buildNavItem(context, icon: Icons.security, title: "시스템 로그", index: 3),
              ],
            ),
          ),

          // 3. 하단 대시보드 복귀 버튼
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white70),
            title: const Text("대시보드로 돌아가기", style: TextStyle(color: Colors.white70)),
            onTap: onBackToDashboard,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // 메뉴 생성 헬퍼 함수
  Widget _buildNavItem(BuildContext context, {required IconData icon, required String title, required int index}) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white54),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: () {
        onItemSelected(index);
      },
    );
  }
}