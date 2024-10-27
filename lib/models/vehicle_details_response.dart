import 'package:json_annotation/json_annotation.dart';

part 'vehicle_details_response.g.dart';

@JsonSerializable()
class VehicleDetailsResponse {
  @JsonKey(name: 'userID')
  String? userID;
  @JsonKey(name: 'vehicleID')
  String? vehicleID;
  @JsonKey(name: 'vehicleNo')
  String? vehicleNo;
  @JsonKey(name: 'parkingTicketID')
  String? parkingTicketID;
  @JsonKey(name: 'vehicleType')
  String? vehicleType;
  @JsonKey(name: 'customerName')
  String? customerName;
  @JsonKey(name: 'totalParkingCharges')
  String? parkingCharges;
  @JsonKey(name: 'mobileNo')
  String? mobileNo;
  @JsonKey(name: 'errorMessage')
  String? errorMessage;

  VehicleDetailsResponse(
      {this.userID,
        this.vehicleID,
        this.vehicleNo,
        this.parkingTicketID,
        this.vehicleType,
        this.customerName,
        this.parkingCharges,
        this.mobileNo,
      this.errorMessage});

  factory VehicleDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDetailsResponseToJson(this);
}
