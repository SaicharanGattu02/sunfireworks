import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'AssignedOrdersRepo.dart';
import 'AssignedOrdersStates.dart';

class AssignedOrdersCubit extends Cubit<AssignedOrdersStates> {
  final AssignedOrdersRepo assignedOrdersRepo;

  AssignedOrdersCubit(this.assignedOrdersRepo)
    : super(AssignedOrdersInitially());

  // Fetch data and update state
  Future<void> fetchAssignedOrders() async {
    try {
      emit(AssignedOrdersLoading());
      final assignedOrders = await assignedOrdersRepo.getAssignedOrders();

      if (assignedOrders != null && assignedOrders.success == 1) {
        emit(AssignedOrdersLoaded(assignedOrders));
      } else {
        emit(AssignedOrdersFailure('No assigned orders available'));
      }
    } catch (e) {
      emit(AssignedOrdersFailure(e.toString()));
    }
  }
}
