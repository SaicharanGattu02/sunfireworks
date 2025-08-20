import '../../../../Models/SuccessModel.dart';
import '../../../../remote_data_source.dart';

abstract class CustomerGenerateOtpRepo {
  Future<SuccessModel?> generateOtp(Map<String, dynamic> data);
}

class CustomerGenerateOtpRepoImpl implements CustomerGenerateOtpRepo {
  final RemoteDataSource remoteDataSource;

  CustomerGenerateOtpRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> generateOtp(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.generateOtp(
        data,
      ); // Assuming you have a `RemoteDataSource` class
    } catch (e) {
      throw Exception('Failed to generate OTP');
    }
  }
}
