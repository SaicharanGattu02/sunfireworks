import '../../../../Models/SuccessModel.dart';

abstract class CarDriverOTPStates {}

class CarDriverOTPInitially extends CarDriverOTPStates {}

class CarDriverOTPLoading extends CarDriverOTPStates {}

class CarDriverOTPGenerated extends CarDriverOTPStates {
  final SuccessModel successModel;
  CarDriverOTPGenerated(this.successModel);
}

class CarDriverOTPVerified extends CarDriverOTPStates {
  final SuccessModel successModel;
  CarDriverOTPVerified(this.successModel);
}

class CarDriverOTPFailure extends CarDriverOTPStates {
  final String error;

  CarDriverOTPFailure(this.error);
}
