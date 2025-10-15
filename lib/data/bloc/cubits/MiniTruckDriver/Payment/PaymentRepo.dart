import 'package:sunfireworks/data/Models/CreatePaymentOrderModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

abstract class PaymentRepo {
  Future<CreatePaymentOrderModel?> createPayment(Map<String, dynamic> data);
  Future<CreatePaymentOrderModel?> verifyPayment(Map<String, dynamic> data);
}

class PaymentRepoImpl implements PaymentRepo {
  RemoteDataSource remoteDataSource;
  PaymentRepoImpl({required this.remoteDataSource});

  @override
  Future<CreatePaymentOrderModel?> createPayment(
    Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.createPayment(data);
  }

  @override
  Future<CreatePaymentOrderModel?> verifyPayment(
    Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.verifyPayment(data);
  }
}
