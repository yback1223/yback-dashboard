import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_users_view_model.dart'; // 👈 정확한 뷰모델 경로 확인

class DashboardFilterSection extends ConsumerStatefulWidget {
  const DashboardFilterSection({super.key});

  @override
  ConsumerState<DashboardFilterSection> createState() => _DashboardFilterSectionState();
}

class _DashboardFilterSectionState extends ConsumerState<DashboardFilterSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // 초기 검색어 상태를 컨트롤러에 반영
    final initialKeyword = ref.read(dashboardUsersViewModelProvider).searchKeyword;
    _searchController = TextEditingController(text: initialKeyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 검색 집행 함수
  void _handleSearch() {
    ref.read(dashboardUsersViewModelProvider.notifier).setSearchKeyword(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardUsersViewModelProvider);
    final notifier = ref.read(dashboardUsersViewModelProvider.notifier);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          // 1. 새로고침 버튼
          Tooltip(
            message: "데이터 새로고침",
            child: IconButton.filledTonal(
              onPressed: () => notifier.fetchUsers(),
              icon: const Icon(Icons.refresh),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const SizedBox(width: 4),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: state.pageSize,
                items: [20, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value개씩 보기"),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) notifier.setPageSize(val);
                },
              ),
            ),
          ),

          const SizedBox(width: 4),
          Container(  
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.selectedServiceType, 
                // [수정] availableServiceTypes 사용
                items: state.availableServiceTypes.map((type) { 
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  if (val != null) notifier.setServiceType(val);
                },
              ),
            ),
          ),

          const SizedBox(width: 4),

          // 3. 검색 영역 (입력창 + 검색 버튼)
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "이름을 입력하세요",
                      prefixIcon: Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    // [핵심] 엔터 키 입력 시 검색 실행
                    onSubmitted: (_) => _handleSearch(),
                  ),
                ),
                // 검색 버튼
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ElevatedButton(
                    onPressed: _handleSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text("검색"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}