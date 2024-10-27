// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(
      Status.fromJson(json['status'] as Map<String, dynamic>),
      Employee.fromJson(json['employee'] as Map<String, dynamic>),
      json['token'] as String,
      json['refreshToken'] as String,
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'employee': instance.employee,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
