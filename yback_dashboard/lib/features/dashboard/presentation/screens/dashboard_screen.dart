import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../providers/dashboard_users_view_model.dart';
import '../widgets/dashboard_filter_section.dart';
import '../widgets/dashboard_table.dart';
import '../widgets/dashboard_top_nav.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // [핵심] 화면이 처음 로드될 때 단 한 번만 데이터를 호출한다.
    Future.microtask(() => 
      ref.read(dashboardUsersViewModelProvider.notifier).init()
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardUsersViewModelProvider);
    final notifier = ref.read(dashboardUsersViewModelProvider.notifier);

    final totalPages = max(1, (state.totalElements / state.pageSize).ceil());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: DashboardTopNav(
        onLogoTap: () {
          notifier.setServiceType('전체');
          notifier.setSearchKeyword('');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const DashboardFilterSection(),
            const SizedBox(height: 16),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => notifier.fetchUsers(),
                                child: const Text("다시 시도"),
                              )
                            ],
                          ),
                        )
                      : DashboardTable(
                          users: state.users,
                          sortAscending: true,
                          onSort: (index, ascending) {
                            print("Column $index 정렬 시도");
                          },
                        ),
            ),
            const SizedBox(height: 16),
            _buildPagination(state.currentPage, totalPages, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int currentPage, int totalPages, DashboardUsersViewModel notifier) {
    const int maxPagesToShow = 5;
    int startPage = max(1, currentPage - 2);
    int endPage = min(totalPages, startPage + maxPagesToShow - 1);

    if (endPage - startPage < maxPagesToShow - 1) {
      startPage = max(1, endPage - maxPagesToShow + 1);
    }

    List<Widget> pageButtons = [];

    pageButtons.add(
      IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: currentPage > 1 ? () => notifier.setPage(currentPage - 1) : null,
      ),
    );

    for (int i = startPage; i <= endPage; i++) {
      final isSelected = i == currentPage;
      pageButtons.add(
        InkWell(
          onTap: () => notifier.setPage(i),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.indigo : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isSelected ? Colors.indigo : Colors.grey.shade300),
            ),
            child: Text(
              i.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    pageButtons.add(
      IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: currentPage < totalPages ? () => notifier.setPage(currentPage + 1) : null,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }
}