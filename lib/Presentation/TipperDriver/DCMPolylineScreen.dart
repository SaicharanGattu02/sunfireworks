import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Import your existing Cubit + States + Repo + Model
import '../../data/Models/TipperDriver/PolylineModel.dart';
import '../../data/bloc/cubits/TipperDriver/DCMPolyline/DCMPolylineCubit.dart';
import '../../data/bloc/cubits/TipperDriver/DCMPolyline/DCMPolylineStates.dart';


class DCMPolylineScreen extends StatefulWidget {
  const DCMPolylineScreen({Key? key}) : super(key: key);

  @override
  State<DCMPolylineScreen> createState() => _DCMPolylineScreenState();
}

class _DCMPolylineScreenState extends State<DCMPolylineScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<DCMPolylineCubit>().fetchDCMPolyline();
  }

  /// ✅ Calculate distance between two LatLngs (in KM)
  double _calculateDistance(LatLng start, LatLng end) {
    const double p = 0.017453292519943295;
    final double a = 0.5 -
        cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) *
            cos(end.latitude * p) *
            (1 - cos((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  /// ✅ Calculate total route distance
  double _getTotalDistance(List<LatLng> points) {
    double total = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _calculateDistance(points[i], points[i + 1]);
    }
    return total;
  }

  /// ✅ Draw polyline and markers on map
  Future<void> _showPolylineOnMap(List<LatLng> points) async {
    if (points.isEmpty) return;

    final GoogleMapController controller = await _mapController.future;

    // Markers
    _markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: points.first,
        infoWindow: const InfoWindow(title: 'Start Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: points.last,
        infoWindow: const InfoWindow(title: 'End Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    // Polyline
    _polylines = {
      Polyline(
        polylineId: const PolylineId('dcm_route'),
        points: points,
        width: 5,
        color: Colors.blueAccent,
      ),
    };

    // Calculate distance
    setState(() {
      _totalDistance = _getTotalDistance(points);
    });

    // Adjust camera
    final bounds = LatLngBounds(
      southwest: LatLng(
        points.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
        points.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        points.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
        points.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
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
      body: BlocConsumer<DCMPolylineCubit, DCMPolylineStates>(
        listener: (context, state) async {
          if (state is DCMPolylineLoaded) {
            final List<Data> raw = state.dcmPolyline.data ?? [];
            final List<LatLng> points = raw
                .where((d) =>
            d.latitude != null &&
                d.longitude != null &&
                double.tryParse(d.latitude!) != null &&
                double.tryParse(d.longitude!) != null)
                .map((d) => LatLng(
              double.parse(d.latitude!),
              double.parse(d.longitude!),
            ))
                .toList();

            await _showPolylineOnMap(points);
          }
        },
        builder: (context, state) {
          if (state is DCMPolylineLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DCMPolylineFailure) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is DCMPolylineLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(17.4481049, 78.3631175),
                    zoom: 15,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    if (!_mapController.isCompleted) {
                      _mapController.complete(controller);
                    }
                  },
                ),

                // Distance Display
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
          }

          return const Center(child: Text("Fetching DCM route..."));
        },
      ),
    );
  }
}
