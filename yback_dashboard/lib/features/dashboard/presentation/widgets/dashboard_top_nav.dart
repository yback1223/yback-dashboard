// lib/features/dashboard/presentation/widgets/dashboard_top_nav.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yback_dashboard/features/auth/data/providers/auth_provider.dart';
import 'package:yback_dashboard/core/constants/app_assets.dart';
import 'package:yback_dashboard/features/admin/presentation/screens/admin_shell_screen.dart';

class DashboardTopNav extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onLogoTap;

  const DashboardTopNav({super.key, required this.onLogoTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👈 authNotifierProvider로 수정 (AsyncValue<AdminSession?> 반환)
    final session = ref.watch(authProvider); 
    final user = session.value;

    final serviceGroupImageUrl = user?.serviceGroupImageUrl ?? '';
    final serviceGroupName = user?.serviceGroupName ?? '';
    final username = user?.username ?? '';
    final isIllusionist = user?.userRole == 'ILLUSIONIST';

    final String fullImageUrl = 'https://dashboard.ainuri.kr$serviceGroupImageUrl';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 280,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: InkWell(
          onTap: onLogoTap,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fullImageUrl,
                  height: 40, width: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      Image.asset(AppAssets.illusionistsLogo2, height: 40, width: 40),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                serviceGroupName,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        "AI 솔루션 계정 현황",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        // 🛡️ ILLUSIONIST 권한일 때만 마스터 관리 아이콘 노출
        if (isIllusionist)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Tooltip(
              message: "마스터 관리", // 아이콘만 있을 때는 툴팁이 필수다
              child: IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                color: Colors.indigoAccent, // 강조하고 싶은 색상
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminShellScreen()),
                  );
                },
              ),
            ),
          ),
        if (user != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("$username 님", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                const Text("Group Admin", style: TextStyle(color: Colors.grey, fontSize: 9)),
              ],
            ),
          ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
          onPressed: () => ref.read(authProvider.notifier).logout(),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}