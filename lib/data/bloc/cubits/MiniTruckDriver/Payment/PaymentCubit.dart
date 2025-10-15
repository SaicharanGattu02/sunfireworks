import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/Payment/PaymentRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/Payment/PaymentStates.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentRepo paymentRepo;
  PaymentCubit(this.paymentRepo) : super(PaymentInitially());

  Future<void> createPayment(Map<String, dynamic> data) async {
    emit(PaymentLoading());
    try {
      final response = await paymentRepo.createPayment(data);
      if (response != null && response.success == true) {
        emit(PaymentCreated(response));
      } else {
        emit(PaymentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(PaymentFailure("Create Payment Failed"));
    }
  }

  Future<void> verifyPayment(Map<String, dynamic> data) async {
    emit(PaymentLoading());
    try {
      final response = await paymentRepo.verifyPayment(data);
      if (response != null && response.success == true) {
        emit(PaymentVerified(response));
      } else {
        emit(PaymentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(PaymentFailure("Create Payment Failed"));
    }
  }
}
