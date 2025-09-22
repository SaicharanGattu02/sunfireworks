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
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.Granularity
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.Priority
import com.google.android.gms.location.SettingsClient
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

data class LocationReq(
    val latitude: String,
    val longitude: String,
    val location: String
)

class LocationService : Service() {

    // ===== Constants =====
    private val CHANNEL_ID = "location_service_channel"
    private val NOTIF_ID = 1001
    private val TAG = "LocationService"

    // intervals
    private val HIGH_ACC_INTERVAL_MS = 10_000L
    private val HIGH_ACC_FASTEST_MS = 5_000L
    private val BALANCED_INTERVAL_MS = 15_000L
    private val BALANCED_FASTEST_MS = 7_500L
    private val FALLBACK_SWITCH_DELAY_MS = 30_000L // switch to balanced if GPS not locking

    // throttle sending to server
    private val MIN_TIME_BETWEEN_SEND_MS = 15_000L
    private val MIN_DISTANCE_BETWEEN_SEND_M = 30f

    // members
    private lateinit var fusedLocationClient: com.google.android.gms.location.FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private lateinit var settingsClient: SettingsClient

    private lateinit var highAccRequest: LocationRequest
    private lateinit var balancedRequest: LocationRequest

    private var useBalanced = false
    private var fallbackHandler: Handler? = null
    private var fallbackRunnable: Runnable? = null

    private var token: String = ""
    private var role: String = ""

    private var lastSentAt: Long = 0L
    private var lastSentLat: Double? = null
    private var lastSentLng: Double? = null

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
        settingsClient = LocationServices.getSettingsClient(this)

        // Build requests
        highAccRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, HIGH_ACC_INTERVAL_MS
        )
            .setMinUpdateIntervalMillis(HIGH_ACC_FASTEST_MS)
            .setWaitForAccurateLocation(false) // do not block for perfect GPS
            .setGranularity(Granularity.GRANULARITY_PERMISSION_LEVEL)
            .build()

        balancedRequest = LocationRequest.Builder(
            Priority.PRIORITY_BALANCED_POWER_ACCURACY, BALANCED_INTERVAL_MS
        )
            .setMinUpdateIntervalMillis(BALANCED_FASTEST_MS)
            .setGranularity(Granularity.GRANULARITY_PERMISSION_LEVEL)
            .build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                val loc = result.lastLocation ?: return
                Log.d(TAG, "Location: ${loc.latitude}, ${loc.longitude}, acc=${loc.accuracy}")

                // If we switched to balanced already, keep going; otherwise if we finally got a fix, cancel fallback switch
                if (!useBalanced) {
                    cancelFallbackSwitch()
                }

                // Throttle by time + distance
                val now = System.currentTimeMillis()
                val shouldSendByTime = now - lastSentAt >= MIN_TIME_BETWEEN_SEND_MS
                val shouldSendByDistance = when {
                    lastSentLat == null || lastSentLng == null -> true
                    else -> {
                        val d = distanceMeters(
                            lastSentLat!!, lastSentLng!!,
                            loc.latitude, loc.longitude
                        )
                        d >= MIN_DISTANCE_BETWEEN_SEND_M
                    }
                }

                if (shouldSendByTime && shouldSendByDistance) {
                    lastSentAt = now
                    lastSentLat = loc.latitude
                    lastSentLng = loc.longitude

                    // Reverse geocode off main thread (optional)
                    serviceScope.launch {
                        val address = withContext(Dispatchers.IO) {
                            resolveAddress(loc.latitude, loc.longitude)
                        }
                        Log.d(TAG, "Address: $address")

                        // Send async (Retrofit enqueue) or switch to suspend if you have it
                        sendLocationToServer(
                            lat = loc.latitude.toString(),
                            lng = loc.longitude.toString()
                        )
                    }
                }
            }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Foreground notification
        createNotificationChannel()
        val text = intent?.getStringExtra("inputExtra") ?: "Location Service running"
        showNotification(text)

        // Read token/role stored by Flutter shared_preferences
        token = getAccessToken(applicationContext) ?: ""
        role = getRole(applicationContext) ?: ""
        Log.d(TAG, "Token present=${token.isNotBlank()} role=$role")

        // Permission check
        val fineGranted = ActivityCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
        val coarseGranted = ActivityCompat.checkSelfPermission(
            this, android.Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!fineGranted && !coarseGranted) {
            Log.w(TAG, "Missing location permission; stopping service.")
            stopSelf()
            return START_NOT_STICKY
        }

        // Settings check (do not crash if not satisfied; just log)
        val settingsRequest = LocationSettingsRequest.Builder()
            .addLocationRequest(highAccRequest)
            .build()
        settingsClient.checkLocationSettings(settingsRequest)
            .addOnFailureListener { e ->
                Log.w(TAG, "Location settings not satisfied: $e")
            }

        // Start with HIGH accuracy, set a fallback switch to BALANCED after delay if needed
        useBalanced = false
        requestUpdates(highAccRequest)
        scheduleFallbackSwitch()

        return START_STICKY
    }

    private fun requestUpdates(request: LocationRequest) {
        fusedLocationClient.requestLocationUpdates(
            request,
            locationCallback,
            Looper.getMainLooper()
        )
        Log.d(TAG, "Requested updates with priority=${request.priority}")
    }

    private fun removeUpdates() {
        fusedLocationClient.removeLocationUpdates(locationCallback)
        Log.d(TAG, "Removed location updates")
    }

    private fun scheduleFallbackSwitch() {
        cancelFallbackSwitch()
        fallbackHandler = Handler(Looper.getMainLooper())
        fallbackRunnable = Runnable {
            if (!useBalanced) {
                Log.d(TAG, "Switching to BALANCED due to no quick GPS lock")
                removeUpdates()
                useBalanced = true
                requestUpdates(balancedRequest)
            }
        }
        fallbackHandler?.postDelayed(fallbackRunnable!!, FALLBACK_SWITCH_DELAY_MS)
    }

    private fun cancelFallbackSwitch() {
        fallbackRunnable?.let { fallbackHandler?.removeCallbacks(it) }
        fallbackRunnable = null
        fallbackHandler = null
    }

    // Reverse geocoding (safe background call)
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
            Log.e(TAG, "Geocoder failed", e)
            "Unknown address"
        } catch (e: Exception) {
            Log.e(TAG, "Geocoder unexpected error", e)
            "Unknown address"
        }
    }

    // Token/role from Flutter shared_preferences
    private fun getAccessToken(context: Context): String? {
        val sp: SharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val token = sp.getString("flutter.access_token", "")
        Log.d(TAG, "Access token present=${!token.isNullOrBlank()}")
        return token
    }

    private fun getRole(context: Context): String? {
        val sp: SharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val role = sp.getString("flutter.role", "")
        Log.d(TAG, "Role=$role")
        return role
    }

    // Networking
    private fun sendLocationToServer(lat: String, lng: String) {
        if (token.isBlank()) {
            Log.w(TAG, "No token; skipping send")
            return
        }
        val service = ApiClient.createService(ApiInterface::class.java)
        val location = "$lat,$lng" // no space
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
                    Log.d(TAG, "API success: ${response.body()?.message}")
                } else {
                    Log.e(TAG, "API error[${response.code()}]: ${response.errorBody()?.string()}")
                }
            }

            override fun onFailure(call: RetrofitCall<submitresponse>, t: Throwable) {
                Log.e(TAG, "API failure: ${t.message}", t)
            }
        })
    }

    // Foreground notification bits
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
            // Use a built-in icon to avoid resource errors.
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle("Location running")
            .setContentText(text)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(NOTIF_ID, notification)
    }

    override fun onDestroy() {
        cancelFallbackSwitch()
        removeUpdates()
        serviceScope.cancel()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // ===== Utilities =====
    private fun distanceMeters(lat1: Double, lon1: Double, lat2: Double, lon2: Double): Float {
        val results = FloatArray(1)
        android.location.Location.distanceBetween(lat1, lon1, lat2, lon2, results)
        return results[0]
    }
}
