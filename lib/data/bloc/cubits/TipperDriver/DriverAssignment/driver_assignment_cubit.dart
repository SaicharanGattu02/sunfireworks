import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_states.dart';

class DriverAssignmentCubit extends Cubit<DriverAssignmentStates> {
  DriverAssignmentRepo driverAssignmentRepo;
  DriverAssignmentCubit(this.driverAssignmentRepo)
    : super(DriverAssignmentInitially());

  Future<void> getDriverAssignments() async {
    emit(DriverAssignmentLoading());
    try {
      final response = await driverAssignmentRepo.getDriverAssignments();
      if (response != null && response.success == true) {
        emit(DriverAssignmentLoaded(response));
      } else {
        emit(DriverAssignmentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(DriverAssignmentFailure(e.toString()));
    }
  }
}
