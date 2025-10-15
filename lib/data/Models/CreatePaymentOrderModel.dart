class CreatePaymentOrderModel {
  bool? success;
  String? message;
  Data? data;

  CreatePaymentOrderModel({this.success, this.message, this.data});

  CreatePaymentOrderModel.fromJson(Map<String, dynamic> json) {
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
  int? amount;
  String? currency;
  String? paymentDbId;
  String? key;

  Data({this.orderId, this.amount, this.currency, this.paymentDbId, this.key});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    amount = json['amount'];
    currency = json['currency'];
    paymentDbId = json['payment_db_id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['payment_db_id'] = this.paymentDbId;
    data['key'] = this.key;
    return data;
  }
}
