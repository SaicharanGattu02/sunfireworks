import 'package:sunfireworks/data/Models/GenerateOTPModel.dart';
import 'package:sunfireworks/data/remote_data_source.dart';

import '../../../Models/VerifyOTPModel.dart';

abstract class AuthRepository {
  Future<GenerateOTPModel?> getOTP(Map<String, dynamic> data);
  Future<VerifyOTPModel?> verifyOTP(Map<String, dynamic> data);
  Future<GenerateOTPModel?> forgotPassword(Map<String, dynamic> data);
}

class AuthRepositoryImpl implements AuthRepository {
  RemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GenerateOTPModel?> getOTP(Map<String, dynamic> data) async {
    return await remoteDataSource.getOTP(data);
  }

  @override
  Future<VerifyOTPModel?> verifyOTP(Map<String, dynamic> data) async {
    return await remoteDataSource.verifyOTP(data);
  }

  @override
  Future<GenerateOTPModel?> forgotPassword(Map<String, dynamic> data) async {
    return await remoteDataSource.forgotPassword(data);
  }
}
