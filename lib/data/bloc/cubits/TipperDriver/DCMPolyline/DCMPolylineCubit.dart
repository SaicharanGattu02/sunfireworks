
import 'package:flutter_bloc/flutter_bloc.dart';

import 'DCMPolylineRepo.dart';
import 'DCMPolylineStates.dart';

class DCMPolylineCubit extends Cubit<DCMPolylineStates> {
  final DCMPolylineRepo dcmPolylineRepo;

  DCMPolylineCubit(this.dcmPolylineRepo) : super(DCMPolylineInitially());

  // Fetch data and update state
  Future<void> fetchDCMPolyline() async {
    try {
      emit(DCMPolylineLoading());
      final dcmPolyline = await dcmPolylineRepo.getDCMPolyline();
      if(dcmPolyline != null && dcmPolyline.success == true){
        emit(DCMPolylineLoaded(dcmPolyline));
      } else {
        emit(DCMPolylineFailure(dcmPolyline?.message ?? ""));
      }
    } catch (e) {
      emit(DCMPolylineFailure(e.toString()));
    }
  }
}
