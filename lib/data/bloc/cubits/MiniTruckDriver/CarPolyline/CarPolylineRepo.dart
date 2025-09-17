import '../../../../Models/TipperDriver/PolylineModel.dart';
import '../../../../remote_data_source.dart';

abstract class CarPolylineRepo {
  Future<PolylineModel?> getCarPolyline();
}

class CarPolylineRepoImpl implements CarPolylineRepo {
  final RemoteDataSource remoteDataSource;

  CarPolylineRepoImpl({required this.remoteDataSource});

  @override
  Future<PolylineModel?> getCarPolyline() async {
    try {
      return await remoteDataSource.getCarPolyline();
    } catch (e) {
      throw Exception('Failed to load car polyline');
    }
  }
}