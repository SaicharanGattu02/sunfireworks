import 'package:dio/dio.dart';
import '../services/ApiClient.dart';
import '../services/api_endpoint_urls.dart';
import '../utils/AppLogger.dart';
import 'Models/GenerateOTPModel.dart';
import 'Models/MiniTruckDriver/AssignedOrdersDetailsModel.dart';
import 'Models/MiniTruckDriver/AssignedOrdersModel.dart';
import 'Models/SuccessModel.dart';
import 'Models/TipperDriver/DriverAssignmentModel.dart';
import 'Models/TipperDriver/DriverDetailsModel.dart';
import 'Models/TipperDriver/WaypointWiseBoxesModel.dart';
import 'Models/VerifyOTPModel.dart';

abstract class RemoteDataSource {
  Future<GenerateOTPModel?> getOTP(Map<String, dynamic> data);
  Future<VerifyOTPModel?> verifyOTP(Map<String, dynamic> data);
  Future<GenerateOTPModel?> forgotPassword(Map<String, dynamic> data);
  Future<SuccessModel?> saveTipperLocation(String location);
  Future<SuccessModel?> saveMiniTruckLocation(String location);
  Future<DriverAssignmentModel?> getDriverAssignments();
  Future<WaypointWiseBoxesModel?> getWaypointWiseBoxes();
  Future<DriverDetailsModel?> getDriverDetails();
  Future<AssignedOrdersModel?> getAssignedOrders();
  Future<AssignedOrdersDetailsModel?> getAssignedOrderDetails(String orderId);
  Future<SuccessModel?> updateOrderStatus(String orderId, String status);
  Future<SuccessModel?> generateOtp(Map<String, dynamic> data);
  Future<SuccessModel?> customerVerifyOtp(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;
      final isFile =
          value is String && value.contains('/') && (key.contains('image'));
      if (isFile) {
        formMap[key] = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
      } else {
        formMap[key] = value;
      }
    }

    return FormData.fromMap(formMap);
  }

  @override
  Future<SuccessModel?> customerVerifyOtp(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response response = await ApiClient.post(
        "${APIEndpointUrls.customer_verify_otp}",
        data: formdata,
      );
      AppLogger.log('customerVerifyOtp:${response.data}');
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('customerVerifyOtp :: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> generateOtp(Map<String, dynamic> data) async {
    try {
      final formdata = await buildFormData(data);
      Response response = await ApiClient.post(
        "${APIEndpointUrls.customer_generate_otp}",
        data: formdata,
      );
      AppLogger.log('generateOtp:${response.data}');
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('generateOtp :: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateOrderStatus(String orderId, String status) async {
    try {
      Response response = await ApiClient.put(
        "${APIEndpointUrls.assigned_order_detail}/$orderId/?order_status=$status",
      );
      AppLogger.log('updateOrderStatus:${response.data}');
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('updateOrderStatus :: $e');
      return null;
    }
  }

  @override
  Future<AssignedOrdersDetailsModel?> getAssignedOrderDetails(
    String orderId,
  ) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.assigned_order_detail}",
      );
      AppLogger.log('getAssignedOrderDetails:${response.data}');
      return AssignedOrdersDetailsModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getAssignedOrderDetails :: $e');
      return null;
    }
  }

  @override
  Future<AssignedOrdersModel?> getAssignedOrders() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.assigned_car_orders}",
      );
      AppLogger.log('getAssignedOrders:${response.data}');
      return AssignedOrdersModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getAssignedOrders :: $e');
      return null;
    }
  }

  @override
  Future<DriverDetailsModel?> getDriverDetails() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.driver_details}",
      );
      AppLogger.log('getDriverDetails:${response.data}');
      return DriverDetailsModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getDriverDetails :: $e');
      return null;
    }
  }

  @override
  Future<WaypointWiseBoxesModel?> getWaypointWiseBoxes() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.dcm_waypoint_wiseboxes}",
      );
      AppLogger.log('getWaypointWiseBoxes:${response.data}');
      return WaypointWiseBoxesModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getDriverAssignments :: $e');
      return null;
    }
  }

  @override
  Future<DriverAssignmentModel?> getDriverAssignments() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.driver_assignment}",
      );
      AppLogger.log('getDriverAssignments:${response.data}');
      return DriverAssignmentModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getDriverAssignments :: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> saveMiniTruckLocation(String location) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.car_polyline}?location=$location",
      );
      AppLogger.log('saveMiniTruckLocation:${response.data}');
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('saveMiniTruckLocation :: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> saveTipperLocation(String location) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.dcm_polyline}?location=$location",
      );
      AppLogger.log('saveMiniTruckLocation:${response.data}');
      return SuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('saveMiniTruckLocation :: $e');
      return null;
    }
  }

  @override
  Future<GenerateOTPModel?> forgotPassword(Map<String, dynamic> data) async {
    try {
      final form_data = await buildFormData(data);
      Response response = await ApiClient.post(
        "${APIEndpointUrls.forgot_password}",
        data: form_data,
      );
      AppLogger.log('forgotPassword:${response.data}');
      return GenerateOTPModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('forgotPassword :: $e');
      return null;
    }
  }

  @override
  Future<GenerateOTPModel?> getOTP(Map<String, dynamic> data) async {
    try {
      final form_data = await buildFormData(data);
      Response response = await ApiClient.post(
        "${APIEndpointUrls.generate_otp}",
        data: form_data,
      );
      AppLogger.log('getOTP:${response.data}');
      return GenerateOTPModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getOTP :: $e');
      return null;
    }
  }

  @override
  Future<VerifyOTPModel?> verifyOTP(Map<String, dynamic> data) async {
    try {
      final form_data = await buildFormData(data);
      Response response = await ApiClient.post(
        "${APIEndpointUrls.verify_otp}",
        data: form_data,
      );
      AppLogger.log('verifyOTP:${response.data}');
      return VerifyOTPModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('verifyOTP :: $e');
      return null;
    }
  }
}
