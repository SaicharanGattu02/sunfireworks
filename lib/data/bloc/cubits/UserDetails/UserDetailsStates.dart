import '../../../Models/UserDetailsModel.dart';

abstract class UserDetailsStates {}

class UserDetailsInitially extends UserDetailsStates {}

class UserDetailsLoading extends UserDetailsStates {}

class UserDetailsLoaded extends UserDetailsStates {
  final UserDetailsModel userDetailsModel;

  UserDetailsLoaded(this.userDetailsModel);
}

class UserDetailsFailure extends UserDetailsStates {
  final String error;

  UserDetailsFailure(this.error);
}
