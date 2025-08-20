
import 'package:sunfireworks/data/Models/TipperDriver/WaypointWiseBoxesModel.dart';

abstract class WaypointWiseBoxesStates {}

class WaypointWiseBoxesInitially extends WaypointWiseBoxesStates {}

class WaypointWiseBoxesLoading extends WaypointWiseBoxesStates {}

class WaypointWiseBoxesLoaded extends WaypointWiseBoxesStates {
  WaypointWiseBoxesModel waypointWiseBoxesModel;
  WaypointWiseBoxesLoaded(this.waypointWiseBoxesModel);
}

class WaypointWiseBoxesFailure extends WaypointWiseBoxesStates {
  String error;
  WaypointWiseBoxesFailure(this.error);
}
