
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/SaveMiniTruckLocation/save_minitruck_location_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/SaveMiniTruckLocation/save_minitruck_location_states.dart';

class SaveMiniTruckLocationCubit extends Cubit<SaveMiniTuckLocationStates> {
  SaveMiniTruckLocationRepo saveMiniTruckLocationRepo;
  SaveMiniTruckLocationCubit(this.saveMiniTruckLocationRepo)
      : super(SaveMiniTuckLocationInitially());

  Future<void> saveMiniTruckLocation(String location) async {
    emit(SaveMiniTuckLocationLoading());
    try {
      final response = await saveMiniTruckLocationRepo.saveMiniTruckLocation(
        location,
      );
      if (response != null && response.success == true) {
        emit(SaveMiniTuckLocationLoaded(response));
      } else {
        emit(SaveMiniTuckLocationFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SaveMiniTuckLocationFailure(e.toString()));
    }
  }
}
