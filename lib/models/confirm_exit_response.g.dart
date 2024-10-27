// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_exit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmExitResponse _$ConfirmExitResponseFromJson(Map<String, dynamic> json) =>
    ConfirmExitResponse(
      json['totalParkingCharges'] as String,
      json['successMessage'] as String,
    );

Map<String, dynamic> _$ConfirmExitResponseToJson(
        ConfirmExitResponse instance) =>
    <String, dynamic>{
      'totalParkingCharges': instance.parkingCharges,
      'successMessage': instance.successMessage,
    };
