import 'package:sunfireworks/data/Models/SuccessModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

abstract class StockTransferRepo {
  Future<SuccessModel?> stockTransferApi(Map<String, dynamic> data);
}

class StockTransferRepoImpl implements StockTransferRepo {
  RemoteDataSource remoteDataSource;
  StockTransferRepoImpl({required this.remoteDataSource});
  @override
  Future<SuccessModel?> stockTransferApi(Map<String, dynamic> data) async {
    return await remoteDataSource.stockTransferApi(data);
  }
}
