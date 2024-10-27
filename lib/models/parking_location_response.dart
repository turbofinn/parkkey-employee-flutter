import 'package:json_annotation/json_annotation.dart';
part 'parking_location_response.g.dart';

@JsonSerializable()
class ParkingLocationListResponse {
  final List<ParkingLocationResponse> parkingLocationList;


  ParkingLocationListResponse(this.parkingLocationList);

  factory ParkingLocationListResponse.fromJson(Map<String, dynamic> json) => _$ParkingLocationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationListResponseToJson(this);
}

@JsonSerializable()
class ParkingLocationResponse {
  @JsonKey(name: 'parkingSpaceID')
  final String parkingSpaceID;

  @JsonKey(name: 'parkingSpaceName')
  final String parkingSpaceName;

  @JsonKey(name: 'latitude')
  final String latitude;

  @JsonKey(name: 'longitude')
  final String longitude;


  ParkingLocationResponse(this.parkingSpaceID, this.parkingSpaceName,
      this.latitude, this.longitude);

  factory ParkingLocationResponse.fromJson(Map<String, dynamic> json) => _$ParkingLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationResponseToJson(this);
}
