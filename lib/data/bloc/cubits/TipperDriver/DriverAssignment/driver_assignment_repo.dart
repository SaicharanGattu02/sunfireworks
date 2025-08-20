import 'package:sunfireworks/data/Models/TipperDriver/DriverAssignmentModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

abstract class DriverAssignmentRepo {
  Future<DriverAssignmentModel?> getDriverAssignments();
}

class DriverAssignmentRepoImpl implements DriverAssignmentRepo {
  RemoteDataSource remoteDataSource;
  DriverAssignmentRepoImpl({required this.remoteDataSource});

  @override
  Future<DriverAssignmentModel?> getDriverAssignments() async {
    return await remoteDataSource.getDriverAssignments();
  }
}
