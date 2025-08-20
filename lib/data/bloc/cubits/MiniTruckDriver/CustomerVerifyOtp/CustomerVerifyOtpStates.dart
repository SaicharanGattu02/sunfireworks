import '../../../../Models/SuccessModel.dart';

abstract class CustomerVerifyOtpStates {}

class CustomerVerifyOtpInitially extends CustomerVerifyOtpStates {}

class CustomerVerifyOtpLoading extends CustomerVerifyOtpStates {}

class CustomerVerifyOtpVerified extends CustomerVerifyOtpStates {
  final SuccessModel successModel;

  CustomerVerifyOtpVerified(this.successModel);
}

class CustomerVerifyOtpFailure extends CustomerVerifyOtpStates {
  final String error;

  CustomerVerifyOtpFailure(this.error);
}
