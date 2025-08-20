import 'package:bloc/bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/WayPointWiseBoxes/waypoint_wise_boxes_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/WayPointWiseBoxes/waypoint_wise_boxes_states.dart';

class WaypointWiseBoxesCubit extends Cubit<WaypointWiseBoxesStates> {
  final WaypointWiseBoxesRepo waypointWiseBoxesRepo;

  WaypointWiseBoxesCubit(this.waypointWiseBoxesRepo)
    : super(WaypointWiseBoxesInitially());

  // Fetch data and update state
  Future<void> fetchWaypointWiseBoxes() async {
    try {
      emit(WaypointWiseBoxesLoading());
      final waypointWiseBoxesModel = await waypointWiseBoxesRepo
          .getWaypointWiseBoxes();
      if (waypointWiseBoxesModel != null) {
        emit(WaypointWiseBoxesLoaded(waypointWiseBoxesModel));
      } else {
        emit(WaypointWiseBoxesFailure('Failed to load data'));
      }
    } catch (e) {
      emit(WaypointWiseBoxesFailure(e.toString()));
    }
  }
}
