import 'package:json_annotation/json_annotation.dart';

part 'update_customer_details_request.g.dart';


@JsonSerializable()
class UpdateCustomerDetailsRequest {
  @JsonKey(name: 'source')
  String source;
  @JsonKey(name: 'userID')
  String userID;
  @JsonKey(name: 'vehicleID')
  String vehicleID;
  @JsonKey(name: 'customerName')
  String customerName;
  @JsonKey(name: 'vehicleType')
  String vehicleType;


  UpdateCustomerDetailsRequest(this.source, this.userID, this.vehicleID,
      this.customerName, this.vehicleType);

  factory UpdateCustomerDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerDetailsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCustomerDetailsRequestToJson(this);
}