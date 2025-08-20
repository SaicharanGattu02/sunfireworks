import '../../../../Models/MiniTruckDriver/AssignedOrdersDetailsModel.dart';
import '../../../../remote_data_source.dart';

abstract class AssignedOrdersDetailsRepo {
  Future<AssignedOrdersDetailsModel?> getAssignedOrderDetails(String orderId);
}

class AssignedOrdersDetailsRepoImpl implements AssignedOrdersDetailsRepo {
  final RemoteDataSource remoteDataSource;

  AssignedOrdersDetailsRepoImpl({required this.remoteDataSource});

  @override
  Future<AssignedOrdersDetailsModel?> getAssignedOrderDetails(
    String orderId,
  ) async {
    try {
      return await remoteDataSource.getAssignedOrderDetails(
        orderId,
      ); // Assuming you have a `RemoteDataSource` class
    } catch (e) {
      throw Exception('Failed to load assigned order details');
    }
  }
}
