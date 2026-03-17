// lib/features/admin/domain/entities/user_entity.dart

import 'package:flutter/material.dart';

enum UserStatus {
  safe(Color(0xFF4CAF50), "Safe: The period is ample (30% or more)"),
  warning(
    Color(0xFFFF9800),
    "Warning: Preparation for renewal is required (10% ~ 30%)",
  ),
  danger(
    Color(0xFFF44336),
    "Danger: Immediate action is required (less than 10%)",
  );

  final Color color;
  final String description;

  const UserStatus(this.color, this.description);
}

class UserEntity {
  final int id;
  final String name;
  final String serviceType;
  final String emailId; // 관리자와 대시보드 공통 이메일 속성
  final String password;
  final String role; // 관리자 권한용
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
    required this.password,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.dDay,
    required this.dDayPercent,
    required this.status,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? serviceType,
    String? emailId,
    String? password,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
    int? dDay,
    double? dDayPercent,
    UserStatus? status,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceType: serviceType ?? this.serviceType,
      emailId: emailId ?? this.emailId,
      password: password ?? this.password,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dDay: dDay ?? this.dDay,
      dDayPercent: dDayPercent ?? this.dDayPercent,
      status: status ?? this.status,
    );
  }

  static int toInt(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }

  // 👈 어떤 데이터가 들어와도 double로 정제한다.
  static double toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    try {
      // 상태값 파싱 로직 (percent 기반 보정 포함)
      UserStatus _parseStatus(dynamic statusVal, double percent) {
        if (statusVal != null) {
          final s = statusVal.toString().toUpperCase();
          if (s == 'WARNING') return UserStatus.warning;
          if (s == 'DANGER') return UserStatus.danger;
        }
        if (percent < 0.1) return UserStatus.danger;
        if (percent < 0.3) return UserStatus.warning;
        return UserStatus.safe;
      }

      final double dDayPercent = UserEntity.toDouble(json['dDayPercent']);

      return UserEntity(
        id: UserEntity.toInt(json['id']), // 👈 적용
        name: json['name']?.toString() ?? '',
        serviceType: json['serviceType']?.toString() ?? '',
        emailId: json['emailId']?.toString() ?? '',
        password: json['password'].toString(),
        role: json['role']?.toString() ?? 'USER',
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : DateTime.now(),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'])
            : DateTime.now(),
        dDay: UserEntity.toInt(json['dDay']), // 👈 적용
        dDayPercent: dDayPercent, // 👈 적용
        status: _parseStatus(json['status'], dDayPercent),
      );
    } catch (e) {
      print("🚨 [PARSE ERROR] 이 데이터 때문에 터짐: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceType': serviceType,
      'emailId': emailId,
      'password': password,
      'role': role,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
