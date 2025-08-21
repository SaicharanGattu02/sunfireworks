import '../../../../Models/SuccessModel.dart';
import '../../../../remote_data_source.dart';

abstract class UpdateOrderStatusRepo {
  Future<SuccessModel?> updateOrderStatus(String orderId,Map<String, dynamic> data);
}

class UpdateOrderStatusRepoImpl implements UpdateOrderStatusRepo {
  final RemoteDataSource remoteDataSource;

  UpdateOrderStatusRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> updateOrderStatus(String orderId,Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.updateOrderStatus(orderId, data);
    } catch (e) {
      throw Exception('Failed to update order status');
    }
  }
}
