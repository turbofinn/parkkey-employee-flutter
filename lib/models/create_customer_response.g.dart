// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_customer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCustomerResponse _$CreateCustomerResponseFromJson(
        Map<String, dynamic> json) =>
    CreateCustomerResponse(
      userID: json['userID'] as String,
      vehicleID: json['vehicleID'] as String,
      vehicleNo: json['vehicleNo'] as String,
      parkingTicketID: json['parkingTicketID'] as String?,
      initialCharge: json['initialCharge'] as String,
      paymentMode: json['paymentMode'] as String,
    );

Map<String, dynamic> _$CreateCustomerResponseToJson(
        CreateCustomerResponse instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'vehicleID': instance.vehicleID,
      'vehicleNo': instance.vehicleNo,
      'parkingTicketID': instance.parkingTicketID,
      'initialCharge': instance.initialCharge,
      'paymentMode': instance.paymentMode,
    };
