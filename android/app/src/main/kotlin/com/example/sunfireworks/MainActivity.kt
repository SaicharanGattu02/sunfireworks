package com.crackersworld.android

import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.sunfireworks/location"
    private lateinit var methodChannel: MethodChannel
    private val PERMISSION_REQUEST_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val message = call.argument<String>("message") ?: "Location Service Running"
                    if (arePermissionsGranted()) {
                        // Start FGS from an Activity (foreground context)
                        LocationService.startService(this, message)
                        result.success(null)
                    } else {
                        requestAllNeededPermissions()
                        result.error(
                            "PERMISSION_DENIED",
                            "Permissions are required to start the location service",
                            null
                        )
                    }
                }
                "stopService" -> {
                    LocationService.stopService(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun arePermissionsGranted(): Boolean {
        val fineGranted = ContextCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        val coarseGranted = ContextCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        // Required for starting a Foreground Service of type "location" on Android 10+
        val fgsLocationGranted =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                ContextCompat.checkSelfPermission(
                    this, android.Manifest.permission.FOREGROUND_SERVICE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
            } else true

        // Android 13+ needs POST_NOTIFICATIONS to actually show the FGS notification
        val notifGranted =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                ContextCompat.checkSelfPermission(
                    this, android.Manifest.permission.POST_NOTIFICATIONS
                ) == PackageManager.PERMISSION_GRANTED
            } else true

        // Need FGS-LOCATION AND (FINE or COARSE) AND notifications (Tiramisu+)
        return fgsLocationGranted && (fineGranted || coarseGranted) && notifGranted
    }

    private fun requestAllNeededPermissions() {
        val perms = mutableListOf(
            android.Manifest.permission.ACCESS_FINE_LOCATION,
            android.Manifest.permission.ACCESS_COARSE_LOCATION,
            android.Manifest.permission.FOREGROUND_SERVICE_LOCATION
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            perms += android.Manifest.permission.POST_NOTIFICATIONS
        }

        // Only add BACKGROUND if you truly need passive location without FGS
        // (Most apps using an active Foreground Service don't need this.)
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        //     perms += android.Manifest.permission.ACCESS_BACKGROUND_LOCATION
        // }

        ActivityCompat.requestPermissions(this, perms.toTypedArray(), PERMISSION_REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            // Only start if everything is truly granted
            if (arePermissionsGranted()) {
                LocationService.startService(this, "Location Service Running")
            } else {
                // Don't start; you can show a toast or guidance if needed.
            }
        }
    }
}
