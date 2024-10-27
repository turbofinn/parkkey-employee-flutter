// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDetailsResponse _$VehicleDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    VehicleDetailsResponse(
      userID: json['userID'] as String?,
      vehicleID: json['vehicleID'] as String?,
      vehicleNo: json['vehicleNo'] as String?,
      parkingTicketID: json['parkingTicketID'] as String?,
      vehicleType: json['vehicleType'] as String?,
      customerName: json['customerName'] as String?,
      parkingCharges: json['totalParkingCharges'] as String?,
      mobileNo: json['mobileNo'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$VehicleDetailsResponseToJson(
        VehicleDetailsResponse instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'vehicleID': instance.vehicleID,
      'vehicleNo': instance.vehicleNo,
      'parkingTicketID': instance.parkingTicketID,
      'vehicleType': instance.vehicleType,
      'customerName': instance.customerName,
      'totalParkingCharges': instance.parkingCharges,
      'mobileNo': instance.mobileNo,
      'errorMessage': instance.errorMessage,
    };
