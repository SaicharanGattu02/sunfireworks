import '../../../../Models/TipperDriver/DriverDetailsModel.dart';

abstract class DriverDetailsStates {}

class DriverDetailsInitially extends DriverDetailsStates {}

class DriverDetailsLoading extends DriverDetailsStates {}

class DriverDetailsLoaded extends DriverDetailsStates {
  final DriverDetailsModel driverDetails;

  DriverDetailsLoaded(this.driverDetails);
}

class DriverDetailsFailure extends DriverDetailsStates {
  final String error;

  DriverDetailsFailure(this.error);
}
