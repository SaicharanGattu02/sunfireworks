import 'package:bloc/bloc.dart';
import 'UpdateOrderStatusRepo.dart';
import 'UpdateOrderStatusStates.dart';

class UpdateOrderStatusCubit extends Cubit<UpdateOrderStatusStates> {
  final UpdateOrderStatusRepo updateOrderStatusRepo;

  UpdateOrderStatusCubit(this.updateOrderStatusRepo)
    : super(UpdateOrderStatusInitially());

  Future<void> updateOrderStatus(String orderId,Map<String, dynamic> data) async {
    try {
      emit(UpdateOrderStatusLoading());
      final successModel = await updateOrderStatusRepo.updateOrderStatus(
        orderId,
        data,
      );
      if (successModel != null && successModel.success == true) {
        emit(UpdateOrderStatusUpdated(successModel));
      } else {
        emit(UpdateOrderStatusFailure(successModel?.message ?? ""));
      }
    } catch (e) {
      emit(UpdateOrderStatusFailure(e.toString()));
    }
  }
}
