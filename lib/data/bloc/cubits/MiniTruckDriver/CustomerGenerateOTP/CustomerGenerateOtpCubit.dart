import 'package:bloc/bloc.dart';

import 'CustomerGenerateOtpRepo.dart';
import 'CustomerGenerateOtpStates.dart';

class CustomerGenerateOtpCubit extends Cubit<CustomerGenerateOtpStates> {
  final CustomerGenerateOtpRepo customerGenerateOtpRepo;

  CustomerGenerateOtpCubit(this.customerGenerateOtpRepo)
    : super(CustomerGenerateOtpInitially());

  // Fetch data and update state
  Future<void> generateOtp(Map<String, dynamic> data) async {
    try {
      emit(CustomerGenerateOtpLoading());
      final successModel = await customerGenerateOtpRepo.generateOtp(data);
      if (successModel != null && successModel.success == true) {
        emit(CustomerGenerateOtpGenerated(successModel));
      } else {
        emit(CustomerGenerateOtpFailure(successModel?.message ?? ""));
      }
    } catch (e) {
      emit(CustomerGenerateOtpFailure(e.toString()));
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> data) async {
    try {
      emit(CustomerGenerateOtpLoading());
      final successModel = await customerGenerateOtpRepo.customerVerifyOtp(data);
      if (successModel != null && successModel.success == true) {
        emit(CustomerGenerateOtpVerified(successModel));
      } else {
        emit(CustomerGenerateOtpFailure(successModel?.message ?? ""));
      }
    } catch (e) {
      emit(CustomerGenerateOtpFailure(e.toString()));
    }
  }
}
