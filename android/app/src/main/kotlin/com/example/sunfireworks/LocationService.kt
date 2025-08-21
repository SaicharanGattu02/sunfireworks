package com.example.sunfireworks

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.location.Address
import android.location.Geocoder
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.IOException
import java.util.Locale

data class LocationReq(
    val latitude: String,
    val longitude: String,
    val location: String
)

class LocationService : Service() {

    private val CHANNEL_ID = "location_service_channel"
    private val NOTIF_ID = 1001

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var locationRequest: LocationRequest

    private var token: String = ""
    private var role: String = ""

    companion object {
        fun startService(context: Context, message: String) {
            val startIntent = Intent(context, LocationService::class.java).apply {
                putExtra("inputExtra", message)
            }
            ContextCompat.startForegroundService(context, startIntent)
        }

        fun stopService(context: Context) {
            val stopIntent = Intent(context, LocationService::class.java)
            context.stopService(stopIntent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // 10s interval, 5s fastest
        locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, 10_000L
        )
            .setMinUpdateIntervalMillis(5_000L)
            .build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                val location = result.lastLocation ?: return
                Log.d("Locations", "${location.latitude}, ${location.longitude}")
                val addr = resolveAddress(location.latitude, location.longitude)
                sendLocationToServer(
                    location.latitude.toString(),
                    location.longitude.toString()
                )
            }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()
        val input = intent?.getStringExtra("inputExtra") ?: "Location Service Running"
        showNotification(input)

        token = getAccessToken(applicationContext) ?: ""
        role = getRole(applicationContext) ?: ""

        // Request updates (only if we have permission)
        requestLocationUpdates()

        return START_STICKY
    }

    private fun requestLocationUpdates() {
        val fine = ActivityCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        val coarse = ActivityCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!fine && !coarse) {
            Log.w("LocationService", "Missing location permission; stopping service.")
            stopSelf()
            return
        }

        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            mainLooper
        )
    }

    private fun resolveAddress(lat: Double, lng: Double): String {
        return try {
            val geocoder = Geocoder(this, Locale.getDefault())
            val addresses: List<Address>? = geocoder.getFromLocation(lat, lng, 1)
            if (!addresses.isNullOrEmpty()) {
                addresses[0].getAddressLine(0) ?: "Unknown address"
            } else {
                "Unknown address"
            }
        } catch (e: IOException) {
            Log.e("Geocoder", "Failed to get address", e)
            "Unknown address"
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Location Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                setSound(null, null)
                description = "Channel for location foreground service"
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun showNotification(text: String) {
        val notificationIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentText(text)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(NOTIF_ID, notification)
    }

    private fun getAccessToken(context: Context): String? {
        val sp: SharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val token = sp.getString("flutter.access_token", "")
        Log.d("LocationService", "Access token: $token")
        return token
    }

    private fun getRole(context: Context): String? {
        val sp: SharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val role = sp.getString("flutter.role", "")
        Log.d("LocationService", "Role: $token")
        return role
    }

    private fun sendLocationToServer(lat: String, lng: String) {
        val service = ApiClient.createService(ApiInterface::class.java)
        val location = "$lat, $lng" // no space
        val auth = "Bearer ${token ?: ""}"
        // if-expression returns Call<submitresponse>
        val call: Call<submitresponse> = if (role == "dcm_driver") {
            service.sendDCMLocation(auth, location)
        } else {
            service.sendCARLocation(auth, location)
        }

        call.enqueue(object : Callback<submitresponse> {
            override fun onResponse(
                call: Call<submitresponse>,
                response: Response<submitresponse>
            ) {
                if (response.isSuccessful) {
                    Log.d("API_CALL", "Success: ${response.body()?.message}")
                } else {
                    Log.e("API_CALL", "Error[${response.code()}]: ${response.errorBody()?.string()}")
                }
            }

            override fun onFailure(call: Call<submitresponse>, t: Throwable) {
                Log.e("API_CALL", "Failure: ${t.message}", t)
            }
        })
    }


    override fun onDestroy() {
        super.onDestroy()
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
