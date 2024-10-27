import 'package:json_annotation/json_annotation.dart';

part 'entry_vehicle_list_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EntryVehicleListResponse {
  final List<EntryVehicleListResponseVehicle> entryVehicleList;
  final List<EntryVehicleListResponseVehicle> exitVehicleList;

  EntryVehicleListResponse({
    required this.entryVehicleList,
    required this.exitVehicleList,
  });

  factory EntryVehicleListResponse.fromJson(Map<String, dynamic> json) => _$EntryVehicleListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EntryVehicleListResponseToJson(this);
}

@JsonSerializable()
class EntryVehicleListResponseVehicle {
  final String? vehicleNo;
  final String? customerNo;
  final String? parkingDuration;
  final String? parkingCharge;
  final String? vehicleType;
  final String? parkingLocation;
  final String? parkDate;
  final String? parkedDuration;
  final String? customerName;


  EntryVehicleListResponseVehicle({
    this.vehicleNo,
    this.customerNo,
    this.parkingDuration,
    this.parkingCharge,
    this.vehicleType,
    this.parkingLocation,
    this.parkDate,
    this.parkedDuration,
    this.customerName,
  });

  factory EntryVehicleListResponseVehicle.fromJson(Map<String, dynamic> json) => _$EntryVehicleListResponseVehicleFromJson(json);
  Map<String, dynamic> toJson() => _$EntryVehicleListResponseVehicleToJson(this);
}
