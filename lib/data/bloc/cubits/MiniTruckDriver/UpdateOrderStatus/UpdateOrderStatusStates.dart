import '../../../../Models/SuccessModel.dart';

abstract class UpdateOrderStatusStates {}

class UpdateOrderStatusInitially extends UpdateOrderStatusStates {}

class UpdateOrderStatusLoading extends UpdateOrderStatusStates {}

class UpdateOrderStatusUpdated extends UpdateOrderStatusStates {
  final SuccessModel successModel;
  UpdateOrderStatusUpdated(this.successModel);
}

class UpdateOrderStatusFailure extends UpdateOrderStatusStates {
  final String error;

  UpdateOrderStatusFailure(this.error);
}
