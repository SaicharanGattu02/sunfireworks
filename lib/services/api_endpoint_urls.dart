class APIEndpointUrls {
  // static const String baseUrl = 'http://192.168.80.99:8090/';
  static const String baseUrl = 'https://sunfirework.ozrit.in/';
  static const String apiUrl = 'api/';
  static const String authUrl = 'auth/';
  static const String driverUrl = 'driver/';

  /// auth Urls
  static const String generate_otp = '${authUrl}mobile-otp/';
  static const String verify_otp = '${authUrl}verify-otp/';
  static const String forgot_password = '${authUrl}forgot-password/';
  static const String user_detail = '${authUrl}user-detail/';

  /// driver Urls
  static const String dcm_polyline = '${driverUrl}dcm-polyline/';
  static const String car_polyline = '${driverUrl}car-polyline/';
  static const String driver_assignment = '${driverUrl}driver-assignment/';
  static const String dcm_waypoint_wiseboxes =
      '${driverUrl}dcm-waypoint-wiseboxes';
  static const String driver_details = '${driverUrl}driver-details/';
  static const String assigned_car_orders = '${driverUrl}assigned-car-orders/';
  static const String assigned_order_detail =
      '${driverUrl}assigned-order-detail/';
  static const String customer_generate_otp =
      '${driverUrl}customer-generate-otp/';
  static const String customer_verify_otp = '${driverUrl}customer-verify-otp/';
}
