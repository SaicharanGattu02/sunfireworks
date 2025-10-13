import 'package:sunfireworks/data/remote_data_source.dart';

abstract class StockTransferRepo {
  Future<void> stockTransferApi(Map<String, dynamic> data);
}

class StockTransferRepoImpl implements StockTransferRepo {
  RemoteDataSource remoteDataSource;
  StockTransferRepoImpl({required this.remoteDataSource});
  @override
  Future<void> stockTransferApi(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}
