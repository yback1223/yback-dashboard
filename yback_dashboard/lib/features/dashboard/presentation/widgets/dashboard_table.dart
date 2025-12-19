import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
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
      return const Center(child: Text("검색 결과가 없습니다."));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 전체 너비
        double availableWidth = constraints.maxWidth;
        
        // [수정] 0 대신 화면 너비의 2% 정도만 간격을 줍니다 (너무 붙으면 안 예쁘니까요)
        double spacing = availableWidth * 0.1; 

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // 화면 전체 너비 확보
              constraints: BoxConstraints(minWidth: availableWidth),
              // [핵심 해결책] DataTable을 Center로 감쌉니다.
              // 이렇게 하면 확보된 전체 공간(ConstrainedBox) 안에서 테이블이 정가운데 위치합니다.
              child: Center(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                  
                  // [수정] 0 대신 약간의 숨통(2%) 트여주기
                  columnSpacing: spacing,
                  horizontalMargin: 20, 
                  
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
                      DataCell(Text(user.password ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(
                        // 기존 로직 유지 (화면의 30% 크기)
                        SizedBox(width: availableWidth * 0.3, child: DashboardProgressBar(user: user)),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}