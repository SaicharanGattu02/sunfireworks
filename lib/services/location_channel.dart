import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class LocationBridge {
  static const _channel = MethodChannel('com.sunfireworks/location');
  static const String _serverUrl = 'https://api.example.com/location'; // Replace with your server URL

  static Future<bool> ensurePermissions() async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        print("Location permission granted.");
        return true;
      } else {
        print("Location permission denied.");
        return false;
      }
    } catch (e) {
      print("LocationBridge: Error while requesting permission: $e");
      return false;
    }
  }

  static Future<bool> startService({required String message}) async {
    try {
      final result = await _channel.invokeMethod('startService', {'message': message});
      print("LocationBridge: Service started");
      return result as bool;
    } catch (e) {
      print("LocationBridge: Start service failed: $e");
      return false;
    }
  }

  static Future<void> startListeningToLocationUpdates(LocationHandler onLocationUpdate) async {
    try {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onLocationUpdate') {
          double latitude = call.arguments['latitude'] ?? 0.0;
          double longitude = call.arguments['longitude'] ?? 0.0;
          String address = call.arguments['address'] ?? 'Unknown Address';

          // Send location to server
          await sendLocationToServer(latitude, longitude, address);

          // Pass to callback
          await onLocationUpdate(latitude, longitude, address);
        } else if (call.method == 'onPermissionGranted') {
          await startService(message: 'Tracking location...');
        } else if (call.method == 'onPermissionDenied') {
          print("LocationBridge: Permission denied from native");
        }
      });
    } catch (e) {
      print("LocationBridge: Error in setting location update listener: $e");
    }
  }

  static Future<void> stopService() async {
    try {
      await _channel.invokeMethod('stopService');
      print("LocationBridge: Service stopped");
    } catch (e) {
      print("LocationBridge: Stop service failed: $e");
    }
  }

  static Future<void> sendLocationToServer(double latitude, double longitude, String address) async {
    try {
      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'location': address,
        }),
      );

      if (response.statusCode == 200) {
        print("LocationBridge: Location sent to server successfully");
      } else {
        print("LocationBridge: Failed to send location to server: ${response.statusCode}");
      }
    } catch (e) {
      print("LocationBridge: Error sending location to server: $e");
    }
  }
}

typedef LocationHandler = Future<void> Function(double latitude, double longitude, String address);