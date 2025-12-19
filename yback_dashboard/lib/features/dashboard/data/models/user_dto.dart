import 'package:yback_dashboard/features/dashboard/domain/entities/user_entity.dart';

class UserDto {
  final int id;
  final String name;
  final String serviceType;
  final String emailId;
  final String? password;
  final DateTime startDate;
  final DateTime endDate;
  final int dDay;
  final double dDayPercent;

  UserDto({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.emailId,
    this.password,
    required this.startDate,
    required this.endDate,
    required this.dDay,
    required this.dDayPercent,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      name: json['name'] as String,
      serviceType: json['serviceType'] as String,
      emailId: json['emailId'] as String,
      password: json['password'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      dDay: json['dDay'] as int,
      dDayPercent: (json['dDayPercent'] as num).toDouble(), 
    );
  }

  UserEntity toEntity() {
    final UserStatus computedStatus;
    if (dDayPercent >= 0.3) {
      computedStatus = UserStatus.safe;
    } else if (dDayPercent >= 0.1) {
      computedStatus = UserStatus.warning;
    } else {
      computedStatus = UserStatus.danger;
    }

    return UserEntity(
      id: id,
      name: name,
      serviceType: serviceType,
      emailId: emailId,
      password: password ?? '',
      startDate: startDate,
      endDate: endDate,
      dDay: dDay,
      dDayPercent: dDayPercent,
      status: computedStatus,
    );
  }
}