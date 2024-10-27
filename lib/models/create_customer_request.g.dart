// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_customer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCustomerRequest _$CreateCustomerRequestFromJson(
        Map<String, dynamic> json) =>
    CreateCustomerRequest(
      json['source'] as String,
      json['mobileNo'] as String,
      json['vehicleNo'] as String,
      json['employeeID'] as String,
    );

Map<String, dynamic> _$CreateCustomerRequestToJson(
        CreateCustomerRequest instance) =>
    <String, dynamic>{
      'source': instance.source,
      'mobileNo': instance.mobileNo,
      'vehicleNo': instance.vehicleNo,
      'employeeID': instance.employeeID,
    };
