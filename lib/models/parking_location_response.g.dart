// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingLocationListResponse _$ParkingLocationListResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingLocationListResponse(
      (json['parkingLocationList'] as List<dynamic>)
          .map((e) =>
              ParkingLocationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParkingLocationListResponseToJson(
        ParkingLocationListResponse instance) =>
    <String, dynamic>{
      'parkingLocationList': instance.parkingLocationList,
    };

ParkingLocationResponse _$ParkingLocationResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingLocationResponse(
      json['parkingSpaceID'] as String,
      json['parkingSpaceName'] as String,
      json['latitude'] as String,
      json['longitude'] as String,
    );

Map<String, dynamic> _$ParkingLocationResponseToJson(
        ParkingLocationResponse instance) =>
    <String, dynamic>{
      'parkingSpaceID': instance.parkingSpaceID,
      'parkingSpaceName': instance.parkingSpaceName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
