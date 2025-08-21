import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _destination = const LatLng(17.444802, 78.377393);
  List<List<LatLng>> _routes = [];
  int _activeRouteIndex = 0;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  double _distance = 0;
  String _eta = '';

  static const String _apiKey = 'AIzaSyD0-eauuJ1zBrknaL4uNexkR21cYVOkj7k';
  String _selectedMode = 'driving'; // driving, walking, transit

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = position;
    await _getRoutes(LatLng(position.latitude, position.longitude));
    _trackLocation();
  }

  Future<void> _getRoutes(LatLng origin, {String mode = 'driving'}) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${_destination.latitude},${_destination.longitude}&mode=$mode&alternatives=true&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    _routes = [];
    _eta = '';

    if (json['routes'].isNotEmpty) {
      for (var route in json['routes']) {
        final points = route['overview_polyline']['points'];
        final decodedPoints = PolylinePoints()
            .decodePolyline(points)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();
        _routes.add(decodedPoints);
      }

      // Extract ETA from first route (selected one)
      _eta = json['routes'][_activeRouteIndex]['legs'][0]['duration']['text'];
    }

    _drawPolylines();
    _calculateDistance();
  }

  void _drawPolylines() {
    _polylines.clear();
    for (int i = 0; i < _routes.length; i++) {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_$i'),
          points: _routes[i],
          color: i == _activeRouteIndex ? Colors.blue : Colors.grey,
          width: 8,
          consumeTapEvents: true,
          onTap: () {
            if (i != _activeRouteIndex) {
              setState(() {
                _activeRouteIndex = i;
                _calculateDistance();
                _drawPolylines();
              });
            }
          },
        ),
      );
    }
  }

  void _calculateDistance() {
    double distance = 0.0;
    final route = _routes[_activeRouteIndex];
    for (int i = 0; i < route.length - 1; i++) {
      distance += Geolocator.distanceBetween(
        route[i].latitude,
        route[i].longitude,
        route[i + 1].latitude,
        route[i + 1].longitude,
      );
    }
    setState(() {
      _distance = distance / 1000;
    });
  }

  void _trackLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) async {
            _currentPosition = position;
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude),
              ),
            );
            setState(() {});
          },
        );
  }

  Future<void> _recenterCamera() async {
    final GoogleMapController controller = await _controller.future;

    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    } else {
      // fallback to destination
      controller.animateCamera(CameraUpdate.newLatLng(_destination));
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Route')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : _destination,
              zoom: 14,
            ),
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: _recenterCamera,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance: ${_distance.toStringAsFixed(2)} KM',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (_eta.isNotEmpty)
                    Text('ETA: $_eta', style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      _modeButton('🚗', 'driving'),
                      _modeButton('🚌', 'transit'),
                      _modeButton('🚶', 'walking'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(String emoji, String mode) {
    return IconButton(
      onPressed: () async {
        if (_currentPosition == null) return;
        setState(() {
          _selectedMode = mode;
        });
        await _getRoutes(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          mode: _selectedMode,
        );
      },
      icon: Text(
        emoji,
        style: TextStyle(
          fontSize: 24,
          color: _selectedMode == mode ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}
