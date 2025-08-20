class DriverDetailsModel {
  bool? success;
  String? message;
  List<Data>? data;

  DriverDetailsModel({this.success, this.message, this.data});

  DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? fullName;
  String? mobile;
  String? userImage;
  bool? isActive;
  String? createdAt;
  String? modifiedAt;
  String? vehicle;
  String? vehicleNumber;
  String? color;
  String? model;
  String? company;
  String? image;
  String? driver;

  Data({
    this.id,
    this.fullName,
    this.mobile,
    this.userImage,
    this.isActive,
    this.createdAt,
    this.modifiedAt,
    this.vehicle,
    this.vehicleNumber,
    this.color,
    this.model,
    this.company,
    this.image,
    this.driver,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    mobile = json['mobile'];
    userImage = json['user_image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    vehicle = json['vehicle'];
    vehicleNumber = json['vehicle_number'];
    color = json['color'];
    model = json['model'];
    company = json['company'];
    image = json['image'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['mobile'] = this.mobile;
    data['user_image'] = this.userImage;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['vehicle'] = this.vehicle;
    data['vehicle_number'] = this.vehicleNumber;
    data['color'] = this.color;
    data['model'] = this.model;
    data['company'] = this.company;
    data['image'] = this.image;
    data['driver'] = this.driver;
    return data;
  }
}
