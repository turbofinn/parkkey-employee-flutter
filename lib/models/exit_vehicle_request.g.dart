// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exit_vehicle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExitVehicleRequest _$ExitVehicleRequestFromJson(Map<String, dynamic> json) =>
    ExitVehicleRequest(
      json['parkingTicketID'] as String,
      json['employeeID'] as String,
    );

Map<String, dynamic> _$ExitVehicleRequestToJson(ExitVehicleRequest instance) =>
    <String, dynamic>{
      'parkingTicketID': instance.parkingTicketID,
      'employeeID': instance.employeeID,
    };
