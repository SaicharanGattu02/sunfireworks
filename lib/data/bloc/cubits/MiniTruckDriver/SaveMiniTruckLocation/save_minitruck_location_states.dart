import '../../../../Models/SuccessModel.dart';

abstract class SaveMiniTuckLocationStates {}

class SaveMiniTuckLocationInitially extends SaveMiniTuckLocationStates {}

class SaveMiniTuckLocationLoading extends SaveMiniTuckLocationStates {}

class SaveMiniTuckLocationLoaded extends SaveMiniTuckLocationStates {
  SuccessModel successModel;
  SaveMiniTuckLocationLoaded(this.successModel);
}

class SaveMiniTuckLocationFailure extends SaveMiniTuckLocationStates {
  String error;
  SaveMiniTuckLocationFailure(this.error);
}
