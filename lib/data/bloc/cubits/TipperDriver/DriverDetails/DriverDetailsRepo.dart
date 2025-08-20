import '../../../../Models/TipperDriver/DriverDetailsModel.dart';
import '../../../../remote_data_source.dart';

abstract class DriverDetailsRepo {
  Future<DriverDetailsModel?> getDriverDetails();
}

class DriverDetailsRepoImpl implements DriverDetailsRepo {
  final RemoteDataSource remoteDataSource;

  DriverDetailsRepoImpl({required this.remoteDataSource});

  @override
  Future<DriverDetailsModel?> getDriverDetails() async {
    try {
      return await remoteDataSource
          .getDriverDetails(); // Assuming you have a `RemoteDataSource` class
    } catch (e) {
      throw Exception('Failed to load driver details');
    }
  }
}
