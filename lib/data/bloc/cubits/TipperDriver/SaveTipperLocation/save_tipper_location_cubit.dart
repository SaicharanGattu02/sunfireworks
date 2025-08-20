import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/SaveTipperLocation/save_tipper_location_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/SaveTipperLocation/save_tipper_location_states.dart';

class SaveTipperLocationCubit extends Cubit<SaveTipperLocationStates> {
  SaveTipperLocationRepo saveTipperLocationRepo;
  SaveTipperLocationCubit(this.saveTipperLocationRepo)
    : super(SaveTipperLocationInitially());

  Future<void> saveTipperLocation(String location) async {
    emit(SaveTipperLocationLoading());
    try {
      final response = await saveTipperLocationRepo.saveTipperLocation(
        location,
      );
      if (response != null && response.success == true) {
        emit(SaveTipperLocationLoaded(response));
      } else {
        emit(SaveTipperLocationFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(SaveTipperLocationFailure(e.toString()));
    }
  }
}
