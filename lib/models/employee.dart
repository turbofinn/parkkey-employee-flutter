import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';


@JsonSerializable()
class Employee {
  @JsonKey(name: 'employeeID')
  String employeeID;
  @JsonKey(name: 'vendorID')
  String vendorID;
  @JsonKey(name: 'employeeName')
  String employeeName;
  @JsonKey(name: 'parkingSpaceID')
  String parkingSpaceID;
  @JsonKey(name: 'mobileNo')
  String mobileNo;
  @JsonKey(name: 'employeeStatus')
  String employeeStatus;
  @JsonKey(name: 'gender')
  String gender;
  @JsonKey(name: 'createdDate')
  String createdDate;
  @JsonKey(name: 'updatedDate')
  String updatedDate;


  Employee(
      this.employeeID,
      this.vendorID,
      this.employeeName,
      this.parkingSpaceID,
      this.mobileNo,
      this.employeeStatus,
      this.gender,
      this.createdDate,
      this.updatedDate);

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}