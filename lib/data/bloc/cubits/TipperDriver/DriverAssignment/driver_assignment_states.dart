import 'package:sunfireworks/data/Models/TipperDriver/DriverAssignmentModel.dart';

abstract class DriverAssignmentStates {}

class DriverAssignmentInitially extends DriverAssignmentStates {}

class DriverAssignmentLoading extends DriverAssignmentStates {}

class DriverAssignmentLoaded extends DriverAssignmentStates {
  final DriverAssignmentModel driverAssignmentModel;
  final bool hasNextPage;
  DriverAssignmentLoaded(this.driverAssignmentModel, this.hasNextPage);
}

class DriverAssignmentLoadingMore extends DriverAssignmentStates {
  final DriverAssignmentModel driverAssignmentModel;
  final bool hasNextPage;
  DriverAssignmentLoadingMore(this.driverAssignmentModel, this.hasNextPage);
}

class DriverAssignmentFailure extends DriverAssignmentStates {
  final String error;
  DriverAssignmentFailure(this.error);
}

