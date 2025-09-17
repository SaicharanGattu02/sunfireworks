

import 'package:flutter_bloc/flutter_bloc.dart';

import 'CarPolylineRepo.dart';
import 'CarPolylineStates.dart';

class CarPolylineCubit extends Cubit<CarPolylineStates> {
  final CarPolylineRepo carPolylineRepo;

  CarPolylineCubit(this.carPolylineRepo) : super(CarPolylineInitially());

  // Fetch data and update state
  Future<void> fetchCarPolyline() async {
    try {
      emit(CarPolylineLoading());
      final carPolyline = await carPolylineRepo.getCarPolyline();
      if(carPolyline != null && carPolyline.success == true){
        emit(CarPolylineLoaded(carPolyline));
      } else {
        emit(CarPolylineFailure(carPolyline?.message ?? ""));
      }
    } catch (e) {
      emit(CarPolylineFailure(e.toString()));
    }
  }
}