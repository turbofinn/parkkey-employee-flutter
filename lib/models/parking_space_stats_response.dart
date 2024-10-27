import 'package:json_annotation/json_annotation.dart';

part 'parking_space_stats_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ParkingSpaceStatsResponse {
  final List<Vehicle> entryVehicleList;
  final List<Vehicle> exitVehicleList;
  final String parkingStatus;
  final int totalParkedVehicle;
  final int capacity;
  final int todayRevenue;
  final int vehicleParkedToday;
  final int todayRevenueCash;
  final int todayRevenueOnline;
  int? initialCharge;
  final String? paymentMode;


  ParkingSpaceStatsResponse(
      this.entryVehicleList,
      this.exitVehicleList,
      this.parkingStatus,
      this.totalParkedVehicle,
      this.capacity,
      this.todayRevenue,
      this.vehicleParkedToday,
      this.todayRevenueCash,
      this.todayRevenueOnline,{
        this.initialCharge,
        this.paymentMode
  });

  factory ParkingSpaceStatsResponse.fromJson(Map<String, dynamic> json) => _$ParkingSpaceStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ParkingSpaceStatsResponseToJson(this);
}

@JsonSerializable()
class Vehicle {
  final String? vehicleNo;
  final String? customerNo;
  final String? parkingDuration;
  final String? parkingCharge;
  final String? vehicleType;
  final String? parkingLocation;
  final String? parkDate;
  final String? parkedDuration;
  final String? customerName;


  Vehicle({
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

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
