import 'package:json_annotation/json_annotation.dart';

part 'create_customer_response.g.dart';

@JsonSerializable()
class CreateCustomerResponse {
  @JsonKey(name: 'userID')
  String userID;

  @JsonKey(name: 'vehicleID')
  String vehicleID;

  @JsonKey(name: 'vehicleNo')
  String vehicleNo;

  @JsonKey(name: 'parkingTicketID')
  String? parkingTicketID;

  @JsonKey(name: 'initialCharge') // Updated this line
  String initialCharge; // Changed field name

  @JsonKey(name: 'paymentMode')
  String paymentMode;

  CreateCustomerResponse({
    required this.userID,
    required this.vehicleID,
    required this.vehicleNo,
    this.parkingTicketID,
    required this.initialCharge, // Updated constructor
    required this.paymentMode,
  });

  factory CreateCustomerResponse.fromJson(Map<String, dynamic> json) => _$CreateCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerResponseToJson(this);
}
