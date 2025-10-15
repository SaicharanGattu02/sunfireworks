import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import '../../data/bloc/cubits/MiniTruckDriver/CarPolyline/CarPolylineCubit.dart';
import '../../data/bloc/cubits/MiniTruckDriver/CarPolyline/CarPolylineStates.dart';

class CarPolylineScreen extends StatefulWidget {
  const CarPolylineScreen({Key? key}) : super(key: key);

  @override
  State<CarPolylineScreen> createState() => _CarPolylineScreenState();
}

class _CarPolylineScreenState extends State<CarPolylineScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<CarPolylineCubit>().fetchCarPolyline();
  }

  /// Calculate distance between two LatLng points (in KM)
  double _calculateDistance(LatLng start, LatLng end) {
    const double p = 0.017453292519943295;
    final double a =
        0.5 -
        cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) *
            cos(end.latitude * p) *
            (1 - cos((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // Distance in KM
  }

  /// Calculate total distance of polyline points
  double _getTotalDistance(List<LatLng> points) {
    double total = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _calculateDistance(points[i], points[i + 1]);
    }
    return total;
  }

  /// Set polyline and markers on the map
  Future<void> _setMapData(List<LatLng> points) async {
    if (points.isEmpty) return;

    final GoogleMapController controller = await _controller.future;

    // Set markers
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: points.first,
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: points.last,
        infoWindow: const InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Draw polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('driver_path'),
        visible: true,
        width: 5,
        points: points,
        color: Colors.blue,
      ),
    );

    // Calculate distance
    setState(() {
      _totalDistance = _getTotalDistance(points);
    });

    // Move camera
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            points.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
            points.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            points.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
            points.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
          ),
        ),
        80,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Driver Route History',
          style: TextStyle(
            fontFamily: "roboto",
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<CarPolylineCubit, CarPolylineStates>(
        listener: (context, state) async {
          if (state is CarPolylineLoaded) {
            final rawData = state.carPolyline.data ?? [];
            final List<LatLng> points = rawData
                .where(
                  (d) =>
                      d.latitude != null &&
                      d.longitude != null &&
                      double.tryParse(d.latitude!) != null &&
                      double.tryParse(d.longitude!) != null,
                )
                .map(
                  (d) => LatLng(
                    double.parse(d.latitude!),
                    double.parse(d.longitude!),
                  ),
                )
                .toList();

            await _setMapData(points);
          }
        },
        builder: (context, state) {
          if (state is CarPolylineLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CarPolylineFailure) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is CarPolylineLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(17.4481049, 78.3631175),
                    zoom: 16,
                  ),
                  polylines: _polylines,
                  markers: _markers,
                  onMapCreated: (controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Distance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${_totalDistance.toStringAsFixed(2)} km",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Fetching route data..."));
          }
        },
      ),
    );
  }
}
