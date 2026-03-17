// lib/features/admin/presentation/screens/admin_users_screen.dart  

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_users_view_model.dart';
import '../widgets/admin_users_control_bar.dart'; 
import '../widgets/admin_users_table.dart';
import '../widgets/admin_users_pagination.dart'; 

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminUsersViewModelProvider);
    final notifier = ref.read(adminUsersViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 제네릭 수술을 완료한 컨트롤 바 복구
            AdminUsersControlBar(state: state, notifier: notifier),
            const SizedBox(height: 16),
            
            if (state.errorMessage != null)
              _buildErrorBanner(state.errorMessage!),
            
            // 2. 에러가 없음을 확인한 테이블
            Expanded(
              child: AdminUsersTable(state: state, notifier: notifier),
            ),

            const SizedBox(height: 16),

            // 3. 페이지네이션 복구
            AdminUsersPagination(state: state, notifier: notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Text(message, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}