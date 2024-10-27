// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_space_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingSpaceStatsResponse _$ParkingSpaceStatsResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingSpaceStatsResponse(
      (json['entryVehicleList'] as List<dynamic>)
          .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['exitVehicleList'] as List<dynamic>)
          .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['parkingStatus'] as String,
      (json['totalParkedVehicle'] as num).toInt(),
      (json['capacity'] as num).toInt(),
      (json['todayRevenue'] as num).toInt(),
      (json['vehicleParkedToday'] as num).toInt(),
      (json['todayRevenueCash'] as num).toInt(),
      (json['todayRevenueOnline'] as num).toInt(),
      initialCharge: (json['initialCharge'] as num?)?.toInt(),
      paymentMode: json['paymentMode'] as String?,
    );

Map<String, dynamic> _$ParkingSpaceStatsResponseToJson(
        ParkingSpaceStatsResponse instance) =>
    <String, dynamic>{
      'entryVehicleList':
          instance.entryVehicleList.map((e) => e.toJson()).toList(),
      'exitVehicleList':
          instance.exitVehicleList.map((e) => e.toJson()).toList(),
      'parkingStatus': instance.parkingStatus,
      'totalParkedVehicle': instance.totalParkedVehicle,
      'capacity': instance.capacity,
      'todayRevenue': instance.todayRevenue,
      'vehicleParkedToday': instance.vehicleParkedToday,
      'todayRevenueCash': instance.todayRevenueCash,
      'todayRevenueOnline': instance.todayRevenueOnline,
      'initialCharge': instance.initialCharge,
      'paymentMode': instance.paymentMode,
    };

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
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

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
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
