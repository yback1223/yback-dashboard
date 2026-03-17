import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yback_dashboard/features/admin/domain/entities/user_entity.dart';


class DashboardProgressBar extends StatelessWidget {
  final UserEntity user;

  const DashboardProgressBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // 1. 날짜 계산 로직 (시, 분, 초를 제외한 '날짜' 단위 비교)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(user.endDate.year, user.endDate.month, user.endDate.day);

    // 차이 계산 (남은 일수)
    final int difference = endDay.difference(today).inDays;

    // 2. 상태에 따른 텍스트 및 스타일 결정
    String dDayText;
    Color barColor;
    double progressValue;
    bool isExpired = false;

    if (difference < 0) {
      // 기간이 지난 경우
      dDayText = "기간 만료";
      barColor = Colors.grey.shade600; // 만료 시 차분한 회색
      progressValue = 1.0; // 바를 꽉 채우거나 0으로 설정 (사용자 선택)
      isExpired = true;
    } else if (difference == 0) {
      // 오늘이 종료일인 경우
      dDayText = "D-Day";
      barColor = user.status.color;
      progressValue = user.dDayPercent.clamp(0.0, 1.0);
    } else {
      // 기간이 남은 경우
      dDayText = "D-$difference";
      barColor = user.status.color;
      progressValue = user.dDayPercent.clamp(0.0, 1.0);
    }

    // 3. 툴팁용 날짜 포맷팅
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
          height: 20, // 전체 높이 고정
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // 배경 및 프로그레스 바
                LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 20,
                  color: barColor,
                  backgroundColor: barColor.withValues(alpha: 0.2),
                ),

                // 중앙 정렬된 텍스트 레이어
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 왼쪽: D-Day 또는 상태 메시지
                        Text(
                          dDayText,
                          style: TextStyle(
                            color: isExpired ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            shadows: const [
                              Shadow(blurRadius: 2, color: Colors.black12)
                            ],
                          ),
                        ),
                        
                        // 오른쪽: 퍼센트 (만료되지 않았을 때만 표시)
                        if (!isExpired)
                          Text(
                            '${(progressValue * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 2, color: Colors.black12)
                              ],
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