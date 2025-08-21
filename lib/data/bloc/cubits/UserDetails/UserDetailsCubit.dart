import 'package:bloc/bloc.dart';
import 'UserDetailsRepo.dart';
import 'UserDetailsStates.dart';

class UserDetailsCubit extends Cubit<UserDetailsStates> {
  final UserDetailsRepo userDetailsRepo;

  UserDetailsCubit(this.userDetailsRepo) : super(UserDetailsInitially());

  Future<void> fetchUserDetails() async {
    try {
      emit(UserDetailsLoading());
      final userDetails = await userDetailsRepo.getUserDetails();
      if (userDetails != null && userDetails.success == true) {
        emit(UserDetailsLoaded(userDetails));
      } else {
        emit(UserDetailsFailure(userDetails?.message ?? ""));
      }
    } catch (e) {
      emit(UserDetailsFailure(e.toString()));
    }
  }
}
