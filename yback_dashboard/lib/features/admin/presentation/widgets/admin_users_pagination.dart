// lib/features/admin/presentation/widgets/admin_users_pagination.dart

import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/admin_users_state.dart';
import '../providers/admin_users_view_model.dart';

class AdminUsersPagination extends StatelessWidget {
  final AdminUsersState state;
  final AdminUsersViewModel notifier;

  const AdminUsersPagination({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final totalPages = max(1, (state.totalElements / state.pageSize).ceil());
    const int maxPagesToShow = 5;
    
    int startPage = max(1, state.currentPage - 2);
    int endPage = min(totalPages, startPage + maxPagesToShow - 1);
    
    if (endPage - startPage < maxPagesToShow - 1) {
      startPage = max(1, endPage - maxPagesToShow + 1);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
        ),
        for (int i = startPage; i <= endPage; i++)
          _buildPageButton(i, i == state.currentPage),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: state.currentPage < totalPages ? () => notifier.setPage(state.currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _buildPageButton(int page, bool isSelected) {
    return InkWell(
      onTap: () => notifier.setPage(page),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 36, height: 36, alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? Colors.indigo : Colors.grey.shade300),
        ),
        child: Text(page.toString(), style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}