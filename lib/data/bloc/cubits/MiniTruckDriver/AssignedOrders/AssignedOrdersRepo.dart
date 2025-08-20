import '../../../../Models/MiniTruckDriver/AssignedOrdersModel.dart';
import '../../../../remote_data_source.dart';

abstract class AssignedOrdersRepo {
  Future<AssignedOrdersModel?> getAssignedOrders();
}

class AssignedOrdersRepoImpl implements AssignedOrdersRepo {
  final RemoteDataSource remoteDataSource;

  AssignedOrdersRepoImpl({required this.remoteDataSource});

  @override
  Future<AssignedOrdersModel?> getAssignedOrders() async {
    try {
      return await remoteDataSource.getAssignedOrders();
    } catch (e) {
      throw Exception('Failed to load assigned orders');
    }
  }
}

