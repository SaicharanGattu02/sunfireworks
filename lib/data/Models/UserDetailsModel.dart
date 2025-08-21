class UserDetailsModel {
  bool? success;
  String? message;
  Data? data;

  UserDetailsModel({this.success, this.message, this.data});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? gender;
  String? dateOfBirth;
  String? userRole;

  Data(
      {this.id,
        this.fullName,
        this.email,
        this.mobile,
        this.image,
        this.gender,
        this.dateOfBirth,
        this.userRole});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    userRole = json['user_role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['user_role'] = this.userRole;
    return data;
  }
}
