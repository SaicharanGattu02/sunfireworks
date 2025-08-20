import 'package:bloc/bloc.dart';
import 'CustomerVerifyOtpRepo.dart';
import 'CustomerVerifyOtpStates.dart';

class CustomerVerifyOtpCubit extends Cubit<CustomerVerifyOtpStates> {
  final CustomerVerifyOtpRepo customerVerifyOtpRepo;

  CustomerVerifyOtpCubit(this.customerVerifyOtpRepo)
    : super(CustomerVerifyOtpInitially());

  Future<void> verifyOtp(Map<String, dynamic> data) async {
    try {
      emit(CustomerVerifyOtpLoading());
      final successModel = await customerVerifyOtpRepo.customerVerifyOtp(data);
      if (successModel != null && successModel.success == true) {
        emit(CustomerVerifyOtpVerified(successModel));
      } else {
        emit(CustomerVerifyOtpFailure(successModel?.message ?? ""));
      }
    } catch (e) {
      emit(CustomerVerifyOtpFailure(e.toString()));
    }
  }
}
