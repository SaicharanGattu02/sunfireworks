import '../../../../Models/SuccessModel.dart';

abstract class SaveTipperLocationStates {}

class SaveTipperLocationInitially extends SaveTipperLocationStates {}

class SaveTipperLocationLoading extends SaveTipperLocationStates {}

class SaveTipperLocationLoaded extends SaveTipperLocationStates {
  SuccessModel successModel;
  SaveTipperLocationLoaded(this.successModel);
}

class SaveTipperLocationFailure extends SaveTipperLocationStates {
  String error;
  SaveTipperLocationFailure(this.error);
}
