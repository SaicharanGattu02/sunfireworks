import 'package:flutter_bloc/flutter_bloc.dart';
import 'CarDriverOTPRepo.dart';
import 'CarDriverOTPStates.dart';

class CarDriverOTPCubit extends Cubit<CarDriverOTPStates> {
  final CarDriverOTPRepo carDriverOTPRepo;

  CarDriverOTPCubit(this.carDriverOTPRepo) : super(CarDriverOTPInitially());

  // Generate OTP
  Future<void> generateOTP(Map<String, dynamic> data) async {
    try {
      emit(CarDriverOTPLoading());
      final response = await carDriverOTPRepo.generateOTP(data);
      if (response != null && response.success == true) {
        emit(CarDriverOTPGenerated(response));
      } else {
        emit(CarDriverOTPFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(CarDriverOTPFailure(e.toString()));
    }
  }

  // Verify OTP
  Future<void> verifyOTP(Map<String, dynamic> data) async {
    try {
      emit(CarDriverOTPLoading());
      final response = await carDriverOTPRepo.verifyOTP(data);
      if (response != null && response.success == true) {
        emit(CarDriverOTPVerified(response));
      } else {
        emit(CarDriverOTPFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(CarDriverOTPFailure(e.toString()));
    }
  }
}
