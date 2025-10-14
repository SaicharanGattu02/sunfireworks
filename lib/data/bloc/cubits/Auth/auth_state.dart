import 'package:sunfireworks/data/Models/GenerateOTPModel.dart';

import '../../../Models/VerifyOTPModel.dart';

abstract class AuthStates {}

class AuthInitially extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthGenerateOTP extends AuthStates {
  GenerateOTPModel generateOTPModel;
  AuthGenerateOTP(this.generateOTPModel);
}

class AuthTestLogin extends AuthStates {
  VerifyOTPModel verifyOTPModel;
  AuthTestLogin(this.verifyOTPModel);
}

class AuthVerifyOTP extends AuthStates {
  VerifyOTPModel verifyOTPModel;
  AuthVerifyOTP(this.verifyOTPModel);
}

class AuthFailure extends AuthStates {
  String message;
  AuthFailure(this.message);
}
