class SuccessModel {
  bool? success;
  String? message;
  List<dynamic>? data;

  SuccessModel({this.success, this.message, this.data});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
