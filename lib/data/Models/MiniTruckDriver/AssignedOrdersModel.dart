class AssignedOrdersModel {
  bool? success;
  String? message;
  List<Data>? data;

  AssignedOrdersModel({this.success, this.message, this.data});

  AssignedOrdersModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  String? location;
  Null? distance;
  Null? duration;
  CustomerDetails? customerDetails;
  String? totalAmount;

  Data(
      {this.id,
        this.orderId,
        this.location,
        this.distance,
        this.duration,
        this.customerDetails,
        this.totalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    location = json['location'];
    distance = json['distance'];
    duration = json['duration'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['location'] = this.location;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class CustomerDetails {
  String? customerName;
  String? mobile;
  String? address;

  CustomerDetails({this.customerName, this.mobile, this.address});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    mobile = json['mobile'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    return data;
  }
}
