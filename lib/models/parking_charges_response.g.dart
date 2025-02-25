// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_charges_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingChargesResponse _$ParkingChargesResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingChargesResponse(
      json['parkedDuration'] as String,
      json['parkingCharges'] as String,
      json['payFromWallet'] as bool,
      json['totalParkingCharges'] as String,
    );

Map<String, dynamic> _$ParkingChargesResponseToJson(
        ParkingChargesResponse instance) =>
    <String, dynamic>{
      'parkedDuration': instance.parkedDuration,
      'parkingCharges': instance.parkingCharges,
      'payFromWallet': instance.payFromWallet,
      'totalParkingCharges': instance.totalParkingCharges,
    };
