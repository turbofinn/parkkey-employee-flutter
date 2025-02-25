import 'package:json_annotation/json_annotation.dart';

part 'parking_charges_response.g.dart';


@JsonSerializable()
class ParkingChargesResponse {
  @JsonKey(name: 'parkedDuration')
  String parkedDuration;
  @JsonKey(name: 'parkingCharges')
  String parkingCharges;
  @JsonKey(name: 'payFromWallet')
  bool payFromWallet;
  @JsonKey(name: 'totalParkingCharges')  // New field
  String totalParkingCharges;



  ParkingChargesResponse(
      this.parkedDuration, this.parkingCharges, this.payFromWallet,this.totalParkingCharges);

  factory ParkingChargesResponse.fromJson(Map<String, dynamic> json) => _$ParkingChargesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingChargesResponseToJson(this);
}