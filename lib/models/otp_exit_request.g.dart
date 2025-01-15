// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_exit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpExitRequest _$OtpExitRequestFromJson(Map<String, dynamic> json) =>
    OtpExitRequest(
      json['exitOTP'] as String,
      json['employeeID'] as String,
    );

Map<String, dynamic> _$OtpExitRequestToJson(OtpExitRequest instance) =>
    <String, dynamic>{
      'exitOTP': instance.exitOTP,
      'employeeID': instance.employeeID,
    };
