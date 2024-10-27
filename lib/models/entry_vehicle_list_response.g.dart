// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_vehicle_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntryVehicleListResponse _$EntryVehicleListResponseFromJson(
        Map<String, dynamic> json) =>
    EntryVehicleListResponse(
      entryVehicleList: (json['entryVehicleList'] as List<dynamic>)
          .map((e) => EntryVehicleListResponseVehicle.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      exitVehicleList: (json['exitVehicleList'] as List<dynamic>)
          .map((e) => EntryVehicleListResponseVehicle.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntryVehicleListResponseToJson(
        EntryVehicleListResponse instance) =>
    <String, dynamic>{
      'entryVehicleList':
          instance.entryVehicleList.map((e) => e.toJson()).toList(),
      'exitVehicleList':
          instance.exitVehicleList.map((e) => e.toJson()).toList(),
    };

EntryVehicleListResponseVehicle _$EntryVehicleListResponseVehicleFromJson(
        Map<String, dynamic> json) =>
    EntryVehicleListResponseVehicle(
      vehicleNo: json['vehicleNo'] as String?,
      customerNo: json['customerNo'] as String?,
      parkingDuration: json['parkingDuration'] as String?,
      parkingCharge: json['parkingCharge'] as String?,
      vehicleType: json['vehicleType'] as String?,
      parkingLocation: json['parkingLocation'] as String?,
      parkDate: json['parkDate'] as String?,
      parkedDuration: json['parkedDuration'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$EntryVehicleListResponseVehicleToJson(
        EntryVehicleListResponseVehicle instance) =>
    <String, dynamic>{
      'vehicleNo': instance.vehicleNo,
      'customerNo': instance.customerNo,
      'parkingDuration': instance.parkingDuration,
      'parkingCharge': instance.parkingCharge,
      'vehicleType': instance.vehicleType,
      'parkingLocation': instance.parkingLocation,
      'parkDate': instance.parkDate,
      'parkedDuration': instance.parkedDuration,
      'customerName': instance.customerName,
    };
