class VerifyOTPModel {
  bool? success;
  String? message;
  Data? data;

  VerifyOTPModel({this.success, this.message, this.data});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? fullName;
  String? email;
  String? mobile;
  String? userRole;
  String? gender;
  String? accessToken;
  String? refreshToken;
  String? fcmToken;
  String? tokenType;

  Data(
      {this.id,
        this.fullName,
        this.email,
        this.mobile,
        this.userRole,
        this.gender,
        this.accessToken,
        this.refreshToken,
        this.fcmToken,
        this.tokenType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    userRole = json['user_role'];
    gender = json['gender'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    fcmToken = json['fcm_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['user_role'] = this.userRole;
    data['gender'] = this.gender;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['fcm_token'] = this.fcmToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}
