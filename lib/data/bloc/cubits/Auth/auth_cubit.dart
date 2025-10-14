import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_repository.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthInitially());

  Future<void> getOTP(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.getOTP(data);
      if (response != null && response.success == true) {
        emit(AuthGenerateOTP(response));
      } else {
        emit(AuthFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> verifyOTP(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.verifyOTP(data);
      if (response != null && response.success == true) {
        emit(AuthVerifyOTP(response));
      } else {
        emit(AuthFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> testLogin(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.testLogin(data);
      if (response != null && response.success == true) {
        emit(AuthTestLogin(response));
      } else {
        emit(AuthFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
