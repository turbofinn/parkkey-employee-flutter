import 'package:json_annotation/json_annotation.dart';

part 'exit_vehicle_request.g.dart';


@JsonSerializable()
class ExitVehicleRequest {
  @JsonKey(name: 'parkingTicketID')
  String parkingTicketID;
  @JsonKey(name: 'employeeID')
  String employeeID;


  ExitVehicleRequest(this.parkingTicketID, this.employeeID);

  factory ExitVehicleRequest.fromJson(Map<String, dynamic> json) => _$ExitVehicleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExitVehicleRequestToJson(this);
}