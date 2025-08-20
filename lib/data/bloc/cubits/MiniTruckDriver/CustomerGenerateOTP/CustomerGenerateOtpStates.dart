import '../../../../Models/SuccessModel.dart';

abstract class CustomerGenerateOtpStates {}

class CustomerGenerateOtpInitially extends CustomerGenerateOtpStates {}

class CustomerGenerateOtpLoading extends CustomerGenerateOtpStates {}

class CustomerGenerateOtpGenerated extends CustomerGenerateOtpStates {
  final SuccessModel successModel;

  CustomerGenerateOtpGenerated(this.successModel);
}

class CustomerGenerateOtpFailure extends CustomerGenerateOtpStates {
  final String error;

  CustomerGenerateOtpFailure(this.error);
}
