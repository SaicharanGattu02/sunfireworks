import 'package:sunfireworks/data/Models/CreatePaymentOrderModel.dart';

abstract class PaymentStates{}
class PaymentInitially extends PaymentStates{}
class PaymentLoading extends PaymentStates{}
class PaymentCreated extends PaymentStates{
  CreatePaymentOrderModel createPaymentOrderModel;
  PaymentCreated(this.createPaymentOrderModel);
}
class PaymentVerified extends PaymentStates{
  CreatePaymentOrderModel createPaymentOrderModel;
  PaymentVerified(this.createPaymentOrderModel);
}
class PaymentFailure extends PaymentStates{
  String error;
  PaymentFailure(this.error);
}