// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_customer_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCustomerDetailsRequest _$UpdateCustomerDetailsRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateCustomerDetailsRequest(
      json['source'] as String,
      json['userID'] as String,
      json['vehicleID'] as String,
      json['customerName'] as String,
      json['vehicleType'] as String,
    );

Map<String, dynamic> _$UpdateCustomerDetailsRequestToJson(
        UpdateCustomerDetailsRequest instance) =>
    <String, dynamic>{
      'source': instance.source,
      'userID': instance.userID,
      'vehicleID': instance.vehicleID,
      'customerName': instance.customerName,
      'vehicleType': instance.vehicleType,
    };
