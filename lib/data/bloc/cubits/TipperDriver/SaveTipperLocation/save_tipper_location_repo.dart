import 'package:sunfireworks/data/Models/SuccessModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

abstract class SaveTipperLocationRepo {
  Future<SuccessModel?> saveTipperLocation(String location);
}

class SaveTipperLocationRepoImpl implements SaveTipperLocationRepo {
  RemoteDataSource remoteDataSource;
  SaveTipperLocationRepoImpl({required this.remoteDataSource});
  @override
  Future<SuccessModel?> saveTipperLocation(String location) async {
    return await remoteDataSource.saveTipperLocation(location);
  }
}
