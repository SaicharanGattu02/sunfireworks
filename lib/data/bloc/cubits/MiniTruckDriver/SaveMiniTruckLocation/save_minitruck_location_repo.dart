import '../../../../Models/SuccessModel.dart';
import '../../../../remote_data_source.dart';

abstract class SaveMiniTruckLocationRepo {
  Future<SuccessModel?> saveMiniTruckLocation(String location);
}

class SaveMiniTruckLocationRepoImpl implements SaveMiniTruckLocationRepo {
  RemoteDataSource remoteDataSource;
  SaveMiniTruckLocationRepoImpl({required this.remoteDataSource});
  @override
  Future<SuccessModel?> saveMiniTruckLocation(String location) async {
    return await remoteDataSource.saveMiniTruckLocation(location);
  }
}
