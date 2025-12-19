import 'dart:ui';

enum UserStatus {
  safe(Color(0xFF4CAF50), "Safe: The period is ample (30% or more)"),
  warning(Color(0xFFFF9800), "Warning: Preparation for renewal is required (10% ~ 30%)"),
  danger(Color(0xFFF44336), "Danger: Immediate action is required (less than 10%)");

  final Color color;
  final String description;

  const UserStatus(this.color, this.description);
}

class UserEntity {
  final int id;
  final String name;
  final String serviceType;
  final String emailId;
  final String? password;
  final DateTime startDate;
  final DateTime endDate;
  final int dDay;
  final double dDayPercent;
  final UserStatus status;

  UserEntity({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.emailId,
    this.password,
    required this.startDate,
    required this.endDate,
    required this.dDay,
    required this.dDayPercent,
    required this.status,
  });
}