import 'package:json_annotation/json_annotation.dart';

part 'otp_exit_request.g.dart';


@JsonSerializable()
class OtpExitRequest {

  @JsonKey(name: 'exitOTP')
  String exitOTP;


  OtpExitRequest(this.exitOTP);

  factory OtpExitRequest.fromJson(Map<String, dynamic> json) => _$OtpExitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OtpExitRequestToJson(this);
}