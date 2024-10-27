import 'package:json_annotation/json_annotation.dart';
import 'package:parkey_employee/models/employee.dart';
import 'status.dart';
part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse{

  @JsonKey(name: 'status')
  Status status;
  @JsonKey(name: 'employee')
  Employee employee;
  @JsonKey(name: 'token')
  String token;
  @JsonKey(name: 'refreshToken')
  String refreshToken;


  VerifyOtpResponse(this.status, this.employee, this.token, this.refreshToken);

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);

}