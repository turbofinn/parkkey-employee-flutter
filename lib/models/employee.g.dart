// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      json['employeeID'] as String,
      json['vendorID'] as String,
      json['employeeName'] as String,
      json['parkingSpaceID'] as String,
      json['mobileNo'] as String,
      json['employeeStatus'] as String,
      json['gender'] as String,
      json['createdDate'] as String,
      json['updatedDate'] as String,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'employeeID': instance.employeeID,
      'vendorID': instance.vendorID,
      'employeeName': instance.employeeName,
      'parkingSpaceID': instance.parkingSpaceID,
      'mobileNo': instance.mobileNo,
      'employeeStatus': instance.employeeStatus,
      'gender': instance.gender,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
