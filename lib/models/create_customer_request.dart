import 'package:json_annotation/json_annotation.dart';

part 'create_customer_request.g.dart';


@JsonSerializable()
class CreateCustomerRequest {
  @JsonKey(name: 'source')
  String source;
  @JsonKey(name: 'mobileNo')
  String mobileNo;
  @JsonKey(name: 'vehicleNo')
  String vehicleNo;
  @JsonKey(name: 'employeeID')
  String employeeID;


  CreateCustomerRequest(this.source, this.mobileNo, this.vehicleNo, this.employeeID);

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerRequestToJson(this);
}