import 'package:json_annotation/json_annotation.dart';

part 'exit_otp_response.g.dart';

@JsonSerializable()
class ExitOtpResponse {
  @JsonKey(name: 'parkingTicketID')
  String? parkingTicketID;
  @JsonKey(name: 'vehicleID')
  String? vehicleID;
  @JsonKey(name: 'userID')
  String? userID;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'vehicleNo')
  String? vehicleNo;

  ExitOtpResponse({
    this.parkingTicketID,
    this.vehicleID,
    this.userID,
    this.message,
    this.vehicleNo
  });

  factory ExitOtpResponse.fromJson(Map<String, dynamic> json) => _$ExitOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExitOtpResponseToJson(this);
}
