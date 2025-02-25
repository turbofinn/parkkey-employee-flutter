import 'package:dio/dio.dart';
import 'package:parkey_employee/models/confirm_exit_response.dart';
import 'package:parkey_employee/models/confirm_ticket_request.dart';
import 'package:parkey_employee/models/exit_otp_response.dart';
import 'package:parkey_employee/models/exit_vehicle_request.dart';
import 'package:parkey_employee/models/parking_charges_response.dart';
import 'package:parkey_employee/models/parking_space_stats_response.dart';
import 'package:parkey_employee/models/send_otp_request.dart';
import 'package:parkey_employee/models/verify_otp_request.dart';
import 'package:parkey_employee/models/verify_otp_response.dart';
import 'package:parkey_employee/models/response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../models/create_customer_request.dart';
import '../models/create_customer_response.dart';
import '../models/entry_vehicle_list_response.dart';
import '../models/get_ticket_response.dart';
import '../models/otp_exit_request.dart';
import '../models/parking_location_response.dart';
import '../models/send_otp_response.dart';
import '../models/update_customer_details_request.dart';
import '../models/vehicle_details_response.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: 'https://xkzd75f5kd.execute-api.ap-south-1.amazonaws.com/prod')
abstract class ApiService{
  factory ApiService(Dio dio, {
  String? baseUrl,
  ParseErrorLogger? errorLogger}) = _ApiService;

  @POST('/login-service/send-otp')
  Future<SendOtpResponse> getOtp(@Body() SendOtpRequest sendOtpRequest);

  @POST('/login-service/verify-otp/employee')
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest verifyOtpRequest);

  @POST('/customer-flow-handler/create-customer')
  Future<CreateCustomerResponse> createCustomer(@Body() CreateCustomerRequest createCustomerRequest);

  @POST('/customer-flow-handler/update-customer-details')
  Future<MyResponse> updateCustomer(@Body() UpdateCustomerDetailsRequest updateCustomerDetailsRequest);

  @POST('/ticket-handler/otp-exit-ticket')
  Future<ExitOtpResponse> verifyExitOtp(@Body() OtpExitRequest otpExitRequest);

  @POST('/ticket-handler/exit-ticket')
  Future<ConfirmExitResponse> confirmExit(@Body() ExitVehicleRequest exitVehicleRequest);

  @GET('/customer-flow-handler/get-parking-space-by-city')
  Future<ParkingLocationListResponse> getParkingSpaceList(@Query('city') String city);

  @GET('/customer-flow-handler/get-vehicle-details')
  Future<VehicleDetailsResponse> getVehicleDetails(@Query('vehicleNo') String vehicleNo);

  @POST('/ticket-handler/confirm-ticket')
  Future<MyResponse> confirmTicket(@Body() ConfirmTicketRequest confirmTicketRequest);

  @GET('/employee-handler/get-parking-space-vehicle-history')
  Future<EntryVehicleListResponse> getHistory(@Query('employeeID') String employeeID);

  @GET('/employee-handler/get-parking-space-stats')
  Future<ParkingSpaceStatsResponse> getParkingSpaceStats(@Query('employeeID') String employeeID);

  @GET('/ticket-handler/get-parking-charges')
  Future<ParkingChargesResponse> getParkingCharges(@Query('parkingTicketID') String parkingTicketID);

  @GET('/ticket-handler/get-ticket')
Future<GetTicketResponse> getTicket(
  @Query('parkingTicketID') String parkingTicketID,
  @Query('employeeID') String employeeID  // New parameter
);



}