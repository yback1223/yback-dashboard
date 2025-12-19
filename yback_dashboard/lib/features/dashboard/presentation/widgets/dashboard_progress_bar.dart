import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/user_entity.dart';

class DashboardProgressBar extends StatelessWidget {
  final UserEntity user;

  const DashboardProgressBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷팅
    final startStr = DateFormat('yyyy-MM-dd').format(user.startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(user.endDate);

    return Tooltip(
      message: "시작일: $startStr\n종료일: $endStr",
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.white),
      child: Container(
        width: 250, // 바 너비 고정
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
        height: 20, // ✅ 전체 높이를 딱 20으로 고정 (테이블 행 높이 침범 X)
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // 둥글게
          child: Stack(
            children: [
              // 1. 배경이 되는 프로그레스 바 (꽉 채움)
              LinearProgressIndicator(
                value: user.dDayPercent.clamp(0.0, 1.0),
                minHeight: 20, // ✅ 높이 20 (텍스트가 들어갈 만큼 굵게)
                color: user.status.color,
                backgroundColor: user.status.color.withValues(alpha: 0.2),
              ),

              // 2. 그 위에 올라가는 텍스트 (중앙 정렬)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 왼쪽: D-Day
                      Text(
                        "D-${user.dDay}",
                        style: const TextStyle(
                          color: Colors.black, // 바 안이니 흰색 글씨 추천 (또는 대비되는 색)
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black26)], // 가독성 그림자
                        ),
                      ),
                      // 오른쪽: 퍼센트
                      Text(
                        '${(user.dDayPercent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}