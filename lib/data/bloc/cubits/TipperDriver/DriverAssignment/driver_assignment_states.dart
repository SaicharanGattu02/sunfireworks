import 'package:sunfireworks/data/Models/TipperDriver/DriverAssignmentModel.dart';

abstract class DriverAssignmentStates {}

class DriverAssignmentInitially extends DriverAssignmentStates {}

class DriverAssignmentLoading extends DriverAssignmentStates {}

class DriverAssignmentLoaded extends DriverAssignmentStates {
  DriverAssignmentModel driverAssignmentModel;
  DriverAssignmentLoaded(this.driverAssignmentModel);
}

class DriverAssignmentFailure extends DriverAssignmentStates {
  String error;
  DriverAssignmentFailure(this.error);
}
