class AssignedOrdersDetailsModel {
  bool? success;
  String? message;
  Data? data;

  AssignedOrdersDetailsModel({this.success, this.message, this.data});

  AssignedOrdersDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
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
  dynamic shippingCharge;
  dynamic taxAmount;
  String? totalAmount;
  List<OrderedCustomer>? orderedCustomer;
  List<Orders>? orders;
  bool? isPackCreated;
  List<PackDetails>? packDetails;

  Data({
    this.orderId,
    this.orderStatus,
    this.confirmedThrough,
    this.subTotal,
    this.shippingCharge,
    this.taxAmount,
    this.totalAmount,
    this.orderedCustomer,
    this.orders,
    this.isPackCreated,
    this.packDetails,
  });

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    confirmedThrough = json['confirmed_through'];
    subTotal = json['sub_total'];
    shippingCharge = json['shipping_charge'];
    taxAmount = json['tax_amount'];
    totalAmount = json['total_amount'];
    isPackCreated = json['is_pack_created'];
    if (json['ordered_customer'] != null) {
      orderedCustomer = <OrderedCustomer>[];
      json['ordered_customer'].forEach((v) {
        orderedCustomer!.add(OrderedCustomer.fromJson(v));
      });
    }
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    if (json['pack_details'] != null) {
      packDetails = <PackDetails>[];
      json['pack_details'].forEach((v) {
        packDetails!.add(PackDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['order_id'] = orderId;
    data['order_status'] = orderStatus;
    data['confirmed_through'] = confirmedThrough;
    data['sub_total'] = subTotal;
    data['shipping_charge'] = shippingCharge;
    data['tax_amount'] = taxAmount;
    data['total_amount'] = totalAmount;
    data['is_pack_created'] = isPackCreated;
    if (orderedCustomer != null) {
      data['ordered_customer'] =
          orderedCustomer!.map((v) => v.toJson()).toList();
    }
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (packDetails != null) {
      data['pack_details'] = packDetails!.map((v) => v.toJson()).toList();
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

  OrderedCustomer({
    this.customerName,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.location,
  });

  OrderedCustomer.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    if (json['location'] != null) {
      location = List<double>.from(json['location'].map((x) => x.toDouble()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['customer_name'] = customerName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['location'] = location;
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
    final Map<String, dynamic> data = {};
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['total_amount'] = totalAmount;
    return data;
  }
}

class PackDetails {
  String? id;
  PackOrder? order;
  List<PackItem>? individualItems;
  List<PackItem>? comboItems;
  String? qrCode;
  String? code;

  PackDetails({
    this.id,
    this.order,
    this.individualItems,
    this.comboItems,
    this.qrCode,
    this.code,
  });

  PackDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'] != null ? PackOrder.fromJson(json['order']) : null;
    if (json['individual_items'] != null) {
      individualItems = <PackItem>[];
      json['individual_items'].forEach((v) {
        individualItems!.add(PackItem.fromJson(v));
      });
    }
    if (json['combo_items'] != null) {
      comboItems = <PackItem>[];
      json['combo_items'].forEach((v) {
        comboItems!.add(PackItem.fromJson(v));
      });
    }
    qrCode = json['qr_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (individualItems != null) {
      data['individual_items'] =
          individualItems!.map((v) => v.toJson()).toList();
    }
    if (comboItems != null) {
      data['combo_items'] = comboItems!.map((v) => v.toJson()).toList();
    }
    data['qr_code'] = qrCode;
    data['code'] = code;
    return data;
  }
}

class PackOrder {
  String? id;
  String? orderId;
  String? orderStatus;

  PackOrder({this.id, this.orderId, this.orderStatus});

  PackOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['order_id'] = orderId;
    data['order_status'] = orderStatus;
    return data;
  }
}

class PackItem {
  String? id;
  String? name;

  PackItem({this.id, this.name});

  PackItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
