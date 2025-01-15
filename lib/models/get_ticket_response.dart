import 'package:json_annotation/json_annotation.dart';

part 'get_ticket_response.g.dart';

@JsonSerializable()
class GetTicketResponse {
  @JsonKey(name: 'parkingTicketID')
  String parkingTicketID;
  @JsonKey(name: 'vehicleNo')
  String vehicleNo;
  @JsonKey(name: 'vehicleType')
  String vehicleType;
  @JsonKey(name: 'parkingStatus')
  String parkingStatus;
  @JsonKey(name: 'mobileNo')
  String mobileNo;
  @JsonKey(name: 'parkingLocation')
  String? parkingLocation;
  @JsonKey(name: 'parkedDuration')
  String? parkedDuration;
  @JsonKey(name: 'parkDate')
  String? parkDate;
  @JsonKey(name: 'exitOTP')
  String? exitOTP;
  @JsonKey(name: 'customerName')
  String? customerName;

  // New fields for payment information
   @JsonKey(name: 'payFromWallet')
  bool? payFromWallet;  // New field
  @JsonKey(name: 'initialCharge')
  String? initialCharge;

  GetTicketResponse({
    required this.parkingTicketID,
    required this.vehicleNo,
    required this.vehicleType,
    required this.parkingStatus,
    required this.mobileNo,
    this.parkingLocation,
    this.parkedDuration,
    this.parkDate,
    this.exitOTP,
    this.customerName,
   this.payFromWallet,
    this.initialCharge,
  });

  factory GetTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTicketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTicketResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
