
import '../../../../Models/SuccessModel.dart';
import '../../../../remote_data_source.dart';

abstract class CustomerVerifyOtpRepo {
  Future<SuccessModel?> customerVerifyOtp(Map<String, dynamic> data);
}
class CustomerVerifyOtpRepoImpl implements CustomerVerifyOtpRepo {
  final RemoteDataSource remoteDataSource;

  CustomerVerifyOtpRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> customerVerifyOtp(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.customerVerifyOtp(data); // Pass map data to the data source
    } catch (e) {
      throw Exception('Failed to verify OTP');
    }
  }
}
