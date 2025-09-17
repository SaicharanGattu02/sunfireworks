import '../../../../Models/SuccessModel.dart';
import '../../../../remote_data_source.dart';

abstract class CarDriverOTPRepo {
  Future<SuccessModel?> generateOTP(Map<String, dynamic> data);
  Future<SuccessModel?> verifyOTP(Map<String, dynamic> data);
}

class CarDriverOTPRepoImpl implements CarDriverOTPRepo {
  final RemoteDataSource remoteDataSource;

  CarDriverOTPRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> generateOTP(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.generateCarDriverOTP(data);
    } catch (e) {
      throw Exception('Failed to generate OTP');
    }
  }

  @override
  Future<SuccessModel?> verifyOTP(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.verifyCarDriverOTP(data);
    } catch (e) {
      throw Exception('Failed to verify OTP');
    }
  }
}