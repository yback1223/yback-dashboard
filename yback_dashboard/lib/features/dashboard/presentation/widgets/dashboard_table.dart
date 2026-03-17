import 'package:flutter/material.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';
import 'dashboard_progress_bar.dart';

class DashboardTable extends StatelessWidget {
  final List<UserEntity> users;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int columnIndex, bool ascending) onSort;

  const DashboardTable({
    super.key,
    required this.users,
    this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Text("조회된 유저가 없습니다."),
      ));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // [핵심] 화면의 최대 너비를 확보한다.
        final double fullWidth = constraints.maxWidth;
        
        // 컬럼 간격을 화면 너비에 따라 유동적으로 조절 (전체 너비의 약 5~8%가 적당함)
        final double dynamicSpacing = fullWidth * 0.06;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // 👈 여기서 최소 너비를 부모의 너비(fullWidth)로 강제한다.
              constraints: BoxConstraints(minWidth: fullWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                // 👈 간격을 유동적으로 부여하여 양 끝으로 밀어낸다.
                columnSpacing: dynamicSpacing, 
                horizontalMargin: 24,
                showCheckboxColumn: false,
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                    onSort: onSort, 
                  ),
                  const DataColumn(label: Text('서비스', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(label: Text('계정(Email)', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(label: Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                    label: const Text('신청 기간', style: TextStyle(fontWeight: FontWeight.bold)),
                    onSort: onSort,
                  ),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.name, style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(user.serviceType, style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(user.emailId, style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(user.password, style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(
                      // 프로그레스 바 영역도 화면의 일정 비율을 차지하도록 설정
                      SizedBox(width: fullWidth * 0.25, child: DashboardProgressBar(user: user)),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}