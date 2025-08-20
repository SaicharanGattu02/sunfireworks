import 'package:bloc/bloc.dart';
import 'DriverDetailsRepo.dart';
import 'DriverDetailsStates.dart';

class DriverDetailsCubit extends Cubit<DriverDetailsStates> {
  final DriverDetailsRepo driverDetailsRepo;

  DriverDetailsCubit(this.driverDetailsRepo) : super(DriverDetailsInitially());

  // Fetch data and update state
  Future<void> fetchDriverDetails() async {
    try {
      emit(DriverDetailsLoading());
      final driverDetails = await driverDetailsRepo.getDriverDetails();

      if (driverDetails != null) {
        emit(DriverDetailsLoaded(driverDetails));
      } else {
        emit(DriverDetailsFailure('Failed to load driver details'));
      }
    } catch (e) {
      emit(DriverDetailsFailure(e.toString()));
    }
  }
}
