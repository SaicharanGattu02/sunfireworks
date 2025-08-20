import 'package:bloc/bloc.dart';
import 'AssignedOrdersDetailsRepo.dart';
import 'AssignedOrdersDetailsStates.dart';

class AssignedOrdersDetailsCubit extends Cubit<AssignedOrdersDetailsStates> {
  final AssignedOrdersDetailsRepo assignedOrdersDetailsRepo;

  AssignedOrdersDetailsCubit(this.assignedOrdersDetailsRepo)
    : super(AssignedOrdersDetailsInitially());

  // Fetch data and update state
  Future<void> fetchAssignedOrderDetails(String orderId) async {
    try {
      emit(AssignedOrdersDetailsLoading());
      final assignedOrderDetails = await assignedOrdersDetailsRepo
          .getAssignedOrderDetails(orderId);
      if(assignedOrderDetails!=null && assignedOrderDetails.success==true){
        emit(AssignedOrdersDetailsLoaded(assignedOrderDetails));
      }else{
        emit(AssignedOrdersDetailsFailure(assignedOrderDetails?.message??""));
      }
    } catch (e) {
      emit(AssignedOrdersDetailsFailure(e.toString()));
    }
  }
}
