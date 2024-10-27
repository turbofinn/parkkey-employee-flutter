// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exit_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExitOtpResponse _$ExitOtpResponseFromJson(Map<String, dynamic> json) =>
    ExitOtpResponse(
      parkingTicketID: json['parkingTicketID'] as String?,
      vehicleID: json['vehicleID'] as String?,
      userID: json['userID'] as String?,
      message: json['message'] as String?,
      vehicleNo: json['vehicleNo'] as String?,
    );

Map<String, dynamic> _$ExitOtpResponseToJson(ExitOtpResponse instance) =>
    <String, dynamic>{
      'parkingTicketID': instance.parkingTicketID,
      'vehicleID': instance.vehicleID,
      'userID': instance.userID,
      'message': instance.message,
      'vehicleNo': instance.vehicleNo,
    };
