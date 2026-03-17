import 'package:flutter/material.dart';
import '../providers/admin_users_state.dart';
import '../providers/admin_users_view_model.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';

class AdminUsersTable extends StatelessWidget {
  final AdminUsersState state;
  final AdminUsersViewModel notifier;

  const AdminUsersTable({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.indigo));
    }
    if (state.users.isEmpty) {
      return const Center(child: Text("데이터가 없습니다.", style: TextStyle(color: Colors.grey)));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // 1. 테이블 헤더 (고정)
          _buildHeaderRow(),
          Divider(height: 1, color: Colors.grey.shade300),
          
          // 2. 테이블 본문 (스크롤 가능, 절대 안 터짐)
          Expanded(
            child: ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) { // 👈 여기서의 context는 ListView 아이템의 context다.
                final UserEntity user = state.users[index];
                final UserEntity displayUser = state.editedUsers[user.id] ?? user;
                final bool isSelected = state.selectedIds.contains(user.id);
                final int rowNumber = (state.currentPage - 1) * state.pageSize + index + 1;

                return _buildDataRow(
                  context: context, // 👈 획득한 context 전달
                  user: user,
                  displayUser: displayUser,
                  index: index,
                  rowNumber: rowNumber,
                  isSelected: isSelected,
                );
              },
            ),
          ),


        ],
      ),
    );
  }

  // 💡 헤더 렌더링
  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: state.users.isNotEmpty && state.selectedIds.length == state.users.length,
              onChanged: (val) => notifier.toggleAllSelection(val ?? false),
            ),
          ),
          const Expanded(flex: 1, child: Text("No.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 2, child: Text("이름", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 2, child: Text("서비스 타입", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 3, child: Text("ID (Email)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 2, child: Text("비밀번호", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 2, child: Text("D-Day", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          const Expanded(flex: 1, child: Text("권한", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
        ],
      ),
    );
  }

  // 💡 개별 데이터 로우 렌더링
  Widget _buildDataRow({
    required BuildContext context, // 👈 추가
    required UserEntity user,
    required UserEntity displayUser,
    required int index,
    required int rowNumber,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo.withOpacity(0.05) : (index.isEven ? Colors.white : Colors.grey.shade50),
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (val) => notifier.toggleSelection(user.id),
            ),
          ),
          Expanded(flex: 1, child: Text(rowNumber.toString(), style: const TextStyle(color: Colors.black54))),
          
          Expanded(flex: 2, child: _buildCellInput(displayUser.name, (val) => notifier.updateUserField(user.id, 'name', val))),
          Expanded(flex: 2, child: _buildCellInput(displayUser.serviceType, (val) => notifier.updateUserField(user.id, 'serviceType', val))),
          Expanded(flex: 3, child: _buildCellInput(displayUser.emailId, (val) => notifier.updateUserField(user.id, 'emailId', val))),
          Expanded(flex: 2, child: _buildCellInput(displayUser.password, (val) => notifier.updateUserField(user.id, 'password', val))),
          Expanded(flex: 2, child: _buildDDayBadge(context, user, displayUser)),          

          Expanded(
            flex: 1, 
            child: Text(displayUser.role, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
  // Expanded(flex: 2, child: _buildDDayBadge(context, user, displayUser)),

  Widget _buildDDayBadge(BuildContext context, UserEntity user, UserEntity displayUser) {
    Color badgeColor;
    String text;
    final dDay = displayUser.dDay;

    if (dDay > 0) {
      badgeColor = Colors.green;
      text = "D-$dDay";
    } else if (dDay == 0) {
      badgeColor = Colors.blue;
      text = "D-Day";
    } else {
      badgeColor = Colors.red;
      text = "D+${dDay.abs()}";
    }

    final String startStr = displayUser.startDate.toString().split(' ')[0];
    final String endStr = displayUser.endDate.toString().split(' ')[0];

    return Tooltip(
      message: "시작: $startStr\n종료: $endStr",
      child: UnconstrainedBox( // 👈 [집행] 부모의 강제 확장을 무시하고 자식 크기만큼만 차지하게 함
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => _selectDateRange(context, user.id, displayUser),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withOpacity(0.5)),
            ),
            child: Text(
              text,
              style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _selectDateRange(BuildContext context, int userId, UserEntity displayUser) async {
    final DateTime initialStart = displayUser.startDate;
    final DateTime initialEnd = displayUser.endDate;

    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            // 👈 1. 다이얼로그 자체 가로폭을 넓혀서 입력창 공간 확보
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 650), 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Theme(
                data: Theme.of(context).copyWith(
                  useMaterial3: true,
                  // 🚨 2. 입력 모드(Input Mode)의 TextField를 강제 확장
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    // 👈 상하 패딩을 24로 줘서 입력 박스 높이를 대폭 키움
                    contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.indigo, width: 2),
                    ),
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  // 🚨 3. 입력되는 텍스트(날짜 숫자) 폰트 크기 확장
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  colorScheme: const ColorScheme.light(
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                ),
                child: DateRangePickerDialog(
                  initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  // 필요하다면 처음부터 입력모드로 뜨게 하려면 아래 주석 해제
                  // initialEntryMode: DatePickerEntryMode.input,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      notifier.updateUserField(userId, 'startDate', picked.start);
      notifier.updateUserField(userId, 'endDate', picked.end);
    }
  }


  // 💡 텍스트 입력창
  Widget _buildCellInput(String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo.shade300)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: onChanged,
      ),
    );
  }
}