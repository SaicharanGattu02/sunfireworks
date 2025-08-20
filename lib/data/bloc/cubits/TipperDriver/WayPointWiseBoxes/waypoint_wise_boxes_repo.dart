import 'package:sunfireworks/data/Models/TipperDriver/WaypointWiseBoxesModel.dart';

import '../../../../remote_data_source.dart';

abstract class WaypointWiseBoxesRepo {
  Future<WaypointWiseBoxesModel?> getWaypointWiseBoxes();
}

class WaypointWiseBoxesRepoImpl implements WaypointWiseBoxesRepo {
  RemoteDataSource remoteDataSource;
  WaypointWiseBoxesRepoImpl({required this.remoteDataSource});

  @override
  Future<WaypointWiseBoxesModel?> getWaypointWiseBoxes() async {
    return await remoteDataSource.getWaypointWiseBoxes();
  }
}
