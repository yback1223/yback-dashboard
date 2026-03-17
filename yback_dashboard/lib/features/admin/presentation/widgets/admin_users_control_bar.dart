import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_users_state.dart';
import '../providers/admin_users_view_model.dart';

class AdminUsersControlBar extends ConsumerStatefulWidget {
  final AdminUsersState state;
  final AdminUsersViewModel notifier;

  const AdminUsersControlBar({super.key, required this.state, required this.notifier});

  @override
  ConsumerState<AdminUsersControlBar> createState() => _AdminUsersControlBarState();
}

class _AdminUsersControlBarState extends ConsumerState<AdminUsersControlBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchKeyword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("회원 관리", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(width: 16),
          Container(width: 1, height: 24, color: Colors.grey.shade300),
          const SizedBox(width: 16),

          // 1. 페이지 사이즈
          _buildDropdown<int>(
            value: widget.state.pageSize,
            items: const [20, 50, 100], 
            labelBuilder: (val) => "$val개 보기",
            onChanged: (val) { if (val != null) widget.notifier.setPageSize(val); },
          ),
          const SizedBox(width: 12),

          // 2. 서비스 그룹 필터
          _buildDropdown<String>(
            value: widget.state.availableGroups.contains(widget.state.selectedGroup) ? widget.state.selectedGroup : '전체',
            items: widget.state.availableGroups,
            labelBuilder: (val) => val,
            onChanged: (val) { if (val != null) widget.notifier.setFilterGroup(val); },
          ),
          const SizedBox(width: 12),

          // 3. [신규] 서비스 타입 필터
          _buildDropdown<String>(
            value: widget.state.selectedType.contains(widget.state.selectedType) ? widget.state.selectedType : '전체', 
            items: widget.state.availableTypes, // ViewModel에 availableTypes 필드가 있어야
            labelBuilder: (val) => val,
            onChanged: (val) { if (val != null) widget.notifier.setFilterType(val); },
          ),
          const SizedBox(width: 12),

          // 4. [개선] 검색 필드 (아이콘 통합)
          _buildSearchSection(),

          const Spacer(),
          
          // 5. 액션 버튼 세트
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 입력 필드
        Container(
          width: 220,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(Icons.search, size: 20, color: Colors.indigo.shade400),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "이름 검색",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                  ),
                  // 타이핑할 때마다 키워드 상태 업데이트
                  onChanged: (val) => widget.notifier.setSearchKeyword(val),
                  onSubmitted: (_) => widget.notifier.executeSearch(),
                ),
              ),
              // 텍스트가 있을 때만 삭제 버튼 노출
              if (_searchController.text.isNotEmpty)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.cancel, size: 16, color: Colors.grey.shade400),
                  onPressed: () {
                    _searchController.clear();
                    widget.notifier.setSearchKeyword('');
                    // 삭제 후 즉시 조회할지 여부는 네 선택이지만, 보통은 수동 조회를 권장한다.
                  },
                ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // 2. 명시적 조회 버튼
        SizedBox(
          height: 42,
          child: ElevatedButton.icon(
            onPressed: () => widget.notifier.executeSearch(),
            label: const Text("조회", style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // 🚨 [집행] 체크박스 선택 여부 확인
    final bool hasSelection = widget.state.selectedIds.isNotEmpty;
    final bool hasEdits = widget.state.editedUsers.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 선택 삭제 버튼
        OutlinedButton.icon(
          // 🚨 [집행] 선택된 항목이 있을 때만 클릭 가능
          onPressed: hasSelection ? () => _confirmSelectionDelete(context) : null,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: Text("${widget.state.selectedIds.length}개 삭제"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: BorderSide(color: hasSelection ? Colors.red : Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            // 비활성화 시 배경 및 글자색 처리
            disabledForegroundColor: Colors.grey.shade400,
          ),
        ),
        
        const SizedBox(width: 12),

        // 2. 수정 적용 버튼
        ElevatedButton.icon(
          onPressed: hasEdits ? () => widget.notifier.batchUpdate() : null,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: Text("${widget.state.editedUsers.length}건 수정 적용"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }


  // 🚨 개별 선택 삭제 확인 창
  void _confirmSelectionDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("선택 항목 삭제", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("${widget.state.selectedIds.length}명의 유저를 삭제하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.notifier.batchDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("삭제"),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          items: items.map<DropdownMenuItem<T>>((val) {
            return DropdownMenuItem<T>(
              value: val,
              child: Text(labelBuilder(val)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}