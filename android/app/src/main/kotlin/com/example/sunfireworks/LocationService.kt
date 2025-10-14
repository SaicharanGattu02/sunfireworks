package com.crackersworld.android

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
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.Granularity
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call as RetrofitCall
import retrofit2.Callback as RetrofitCallback
import retrofit2.Response as RetrofitResponse
import java.io.IOException
import java.util.Locale


class LocationService : Service() {

    private val CHANNEL_ID = "location_service_channel"
    private val NOTIF_ID = 1001
    private val TAG = "LocationService"

    // Update every 3 seconds
    private val UPDATE_INTERVAL_MS = 3_000L
    private val FASTEST_INTERVAL_MS = 2_000L

    // Google location clients
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var locationRequest: LocationRequest

    // User session info
    private var token: String = ""
    private var role: String = ""

    // Coroutine scope
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    companion object {
        fun startService(context: Context, message: String = "Location Service running") {
            val intent = Intent(context, LocationService::class.java).apply {
                putExtra("inputExtra", message)
            }
            ContextCompat.startForegroundService(context, intent)
        }

        fun stopService(context: Context) {
            val intent = Intent(context, LocationService::class.java)
            context.stopService(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // Configure for accurate location updates every 3 seconds
        locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            UPDATE_INTERVAL_MS
        )
            .setMinUpdateIntervalMillis(FASTEST_INTERVAL_MS)
            .setWaitForAccurateLocation(true)
            .setGranularity(Granularity.GRANULARITY_PERMISSION_LEVEL)
            .build()

        // Callback for each new location
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                val loc = result.lastLocation ?: return
                Log.d(TAG, "📍 Location: ${loc.latitude}, ${loc.longitude}, acc=${loc.accuracy}")

                // Send immediately to server
                serviceScope.launch {
                    val address = withContext(Dispatchers.IO) {
                        resolveAddress(loc.latitude, loc.longitude)
                    }

                    Log.d(TAG, "Resolved address: $address")

                    sendLocationToServer(
                        lat = loc.latitude.toString(),
                        lng = loc.longitude.toString()
                    )
                }
            }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()
        val text = intent?.getStringExtra("inputExtra") ?: "Location Service running"
        showNotification(text)

        token = getAccessToken(applicationContext) ?: ""
        role = getRole(applicationContext) ?: ""

        // Permission check
        val fineGranted = ActivityCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!fineGranted) {
            Log.w(TAG, "❌ Missing location permission; stopping service.")
            stopSelf()
            return START_NOT_STICKY
        }

        // Start requesting updates every 3 seconds
        requestUpdates()
        return START_STICKY
    }

    private fun requestUpdates() {
        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()
        )
        Log.d(TAG, "✅ Started high-accuracy updates every 3 seconds.")
    }

    private fun removeUpdates() {
        fusedLocationClient.removeLocationUpdates(locationCallback)
        Log.d(TAG, "🛑 Stopped location updates.")
    }

    // Reverse geocoding (convert lat/lng → address)
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
            Log.e(TAG, "Geocoder failed: ${e.message}", e)
            "Unknown address"
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected geocode error: ${e.message}", e)
            "Unknown address"
        }
    }

    // Flutter Shared Preferences access
    private fun getAccessToken(context: Context): String? {
        val sp = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return sp.getString("flutter.access_token", "")
    }

    private fun getRole(context: Context): String? {
        val sp = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return sp.getString("flutter.role", "")
    }

    // Networking - Send location to server
    private fun sendLocationToServer(lat: String, lng: String) {
        if (token.isBlank()) {
            Log.w(TAG, "⚠️ No token; skipping send.")
            return
        }

        val service = ApiClient.createService(ApiInterface::class.java)
        val location = "$lat,$lng"
        val auth = "Bearer $token"

        val call: RetrofitCall<submitresponse> = if (role == "dcm_driver") {
            service.sendDCMLocation(auth, location)
        } else {
            service.sendCARLocation(auth, location)
        }

        call.enqueue(object : RetrofitCallback<submitresponse> {
            override fun onResponse(
                call: RetrofitCall<submitresponse>,
                response: RetrofitResponse<submitresponse>
            ) {
                if (response.isSuccessful) {
                    Log.d(TAG, "📡 Sent: ${response.body()?.message}")
                } else {
                    Log.e(TAG, "❗ API Error [${response.code()}]: ${response.errorBody()?.string()}")
                }
            }

            override fun onFailure(call: RetrofitCall<submitresponse>, t: Throwable) {
                Log.e(TAG, "🚨 API failure: ${t.message}", t)
            }
        })
    }

    // Foreground notification
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Location Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                setSound(null, null)
                description = "Location foreground service"
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
            this, 0, notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle("Location Tracking Active")
            .setContentText(text)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(NOTIF_ID, notification)
    }

    override fun onDestroy() {
        removeUpdates()
        serviceScope.cancel()
        super.onDestroy()
        Log.d(TAG, "💤 LocationService destroyed.")
    }

    override fun onBind(intent: Intent?): IBinder? = null
}

