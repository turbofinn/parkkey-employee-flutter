import 'package:json_annotation/json_annotation.dart';

part 'confirm_exit_response.g.dart';


@JsonSerializable()
class ConfirmExitResponse {
  @JsonKey(name: 'totalParkingCharges')
  String parkingCharges;
  @JsonKey(name: 'successMessage')
  String successMessage;


  ConfirmExitResponse(this.parkingCharges, this.successMessage);

  factory ConfirmExitResponse.fromJson(Map<String, dynamic> json) => _$ConfirmExitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmExitResponseToJson(this);
}