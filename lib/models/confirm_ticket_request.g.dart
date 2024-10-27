// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_ticket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmTicketRequest _$ConfirmTicketRequestFromJson(
        Map<String, dynamic> json) =>
    ConfirmTicketRequest(
      json['parkingTicketID'] as String,
      json['requestType'] as String,
      json['employeeID'] as String,
    );

Map<String, dynamic> _$ConfirmTicketRequestToJson(
        ConfirmTicketRequest instance) =>
    <String, dynamic>{
      'parkingTicketID': instance.parkingTicketID,
      'requestType': instance.requestType,
      'employeeID': instance.employeeID,
    };
