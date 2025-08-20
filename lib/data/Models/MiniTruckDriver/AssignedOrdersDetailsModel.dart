class AssignedOrdersDetailsModel {
  bool? success;
  String? message;
  Data? data;

  AssignedOrdersDetailsModel({this.success, this.message, this.data});

  AssignedOrdersDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  String? orderStatus;
  String? confirmedThrough;
  String? subTotal;
  Null? shippingCharge;
  Null? taxAmount;
  String? totalAmount;
  List<OrderedCustomer>? orderedCustomer;
  List<Orders>? orders;

  Data(
      {this.orderId,
        this.orderStatus,
        this.confirmedThrough,
        this.subTotal,
        this.shippingCharge,
        this.taxAmount,
        this.totalAmount,
        this.orderedCustomer,
        this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    confirmedThrough = json['confirmed_through'];
    subTotal = json['sub_total'];
    shippingCharge = json['shipping_charge'];
    taxAmount = json['tax_amount'];
    totalAmount = json['total_amount'];
    if (json['ordered_customer'] != null) {
      orderedCustomer = <OrderedCustomer>[];
      json['ordered_customer'].forEach((v) {
        orderedCustomer!.add(new OrderedCustomer.fromJson(v));
      });
    }
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    data['confirmed_through'] = this.confirmedThrough;
    data['sub_total'] = this.subTotal;
    data['shipping_charge'] = this.shippingCharge;
    data['tax_amount'] = this.taxAmount;
    data['total_amount'] = this.totalAmount;
    if (this.orderedCustomer != null) {
      data['ordered_customer'] =
          this.orderedCustomer!.map((v) => v.toJson()).toList();
    }
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderedCustomer {
  String? customerName;
  String? mobile;
  String? email;
  String? address;
  String? city;
  String? state;
  String? pincode;
  List<double>? location;

  OrderedCustomer(
      {this.customerName,
        this.mobile,
        this.email,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.location});

  OrderedCustomer.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['location'] = this.location;
    return data;
  }
}

class Orders {
  String? productName;
  int? quantity;
  String? totalAmount;

  Orders({this.productName, this.quantity, this.totalAmount});

  Orders.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    quantity = json['quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}
