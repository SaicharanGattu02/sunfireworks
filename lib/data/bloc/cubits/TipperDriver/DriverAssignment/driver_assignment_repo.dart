import 'package:sunfireworks/data/Models/TipperDriver/DriverAssignmentModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

abstract class DriverAssignmentRepo {
  Future<DriverAssignmentModel?> getDriverAssignments(int tpage);
}

class DriverAssignmentRepoImpl implements DriverAssignmentRepo {
  RemoteDataSource remoteDataSource;
  DriverAssignmentRepoImpl({required this.remoteDataSource});

  @override
  Future<DriverAssignmentModel?> getDriverAssignments(int page) async {
    return await remoteDataSource.getDriverAssignments(page);
  }
}
