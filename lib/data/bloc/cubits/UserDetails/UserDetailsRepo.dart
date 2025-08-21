import '../../../Models/UserDetailsModel.dart';
import '../../../remote_data_source.dart';

abstract class UserDetailsRepo {
  Future<UserDetailsModel?> getUserDetails();
}

class UserDetailsRepoImpl implements UserDetailsRepo {
  final RemoteDataSource remoteDataSource;

  UserDetailsRepoImpl({required this.remoteDataSource});

  @override
  Future<UserDetailsModel?> getUserDetails() async {
    try {
      return await remoteDataSource.getUserDetails();
    } catch (e) {
      throw Exception('Failed to fetch user details');
    }
  }
}
