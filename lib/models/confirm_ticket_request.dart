import 'package:json_annotation/json_annotation.dart';

part 'confirm_ticket_request.g.dart';


@JsonSerializable()
class ConfirmTicketRequest {
  @JsonKey(name: 'parkingTicketID')
  String parkingTicketID;
  @JsonKey(name: 'requestType')
  String requestType;
  @JsonKey(name: 'employeeID')
  String employeeID;


  ConfirmTicketRequest(this.parkingTicketID, this.requestType, this.employeeID);

  factory ConfirmTicketRequest.fromJson(Map<String, dynamic> json) => _$ConfirmTicketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmTicketRequestToJson(this);
}