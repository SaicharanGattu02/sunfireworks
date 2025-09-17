import '../../../../Models/TipperDriver/PolylineModel.dart';

abstract class DCMPolylineStates {}

class DCMPolylineInitially extends DCMPolylineStates {}

class DCMPolylineLoading extends DCMPolylineStates {}

class DCMPolylineLoaded extends DCMPolylineStates {
  final PolylineModel dcmPolyline;

  DCMPolylineLoaded(this.dcmPolyline);
}

class DCMPolylineFailure extends DCMPolylineStates {
  final String error;

  DCMPolylineFailure(this.error);
}