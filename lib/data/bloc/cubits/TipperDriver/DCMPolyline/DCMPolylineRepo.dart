import '../../../../Models/TipperDriver/PolylineModel.dart';
import '../../../../remote_data_source.dart';

abstract class DCMPolylineRepo {
  Future<PolylineModel?> getDCMPolyline();
}

class DCMPolylineRepoImpl implements DCMPolylineRepo {
  final RemoteDataSource remoteDataSource;

  DCMPolylineRepoImpl({required this.remoteDataSource});

  @override
  Future<PolylineModel?> getDCMPolyline() async {
    try {
      return await remoteDataSource.getDCMPolyline();
    } catch (e) {
      throw Exception('Failed to load DCM polyline');
    }
  }
}