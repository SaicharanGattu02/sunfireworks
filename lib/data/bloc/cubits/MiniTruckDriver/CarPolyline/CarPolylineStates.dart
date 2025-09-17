import '../../../../Models/TipperDriver/PolylineModel.dart';

abstract class CarPolylineStates {}

class CarPolylineInitially extends CarPolylineStates {}

class CarPolylineLoading extends CarPolylineStates {}

class CarPolylineLoaded extends CarPolylineStates {
  final PolylineModel carPolyline;

  CarPolylineLoaded(this.carPolyline);
}

class CarPolylineFailure extends CarPolylineStates {
  final String error;

  CarPolylineFailure(this.error);
}