# AndroidX Core (Notifications)
-keep class androidx.core.app.** { *; }
-dontwarn androidx.core.app.**

# Android SDK Classes
-keep class android.app.** { *; }
-dontwarn android.app.**

# Retrofit and Gson
-keep class retrofit2.** { *; }
-keep class okio.** { *; }
-keep class okhttp3.** { *; }
-dontwarn retrofit2.**
-dontwarn okio.**
-dontwarn okhttp3.**
-keepattributes Signature
-keepattributes *Annotation*
-keep class * implements retrofit2.http.** { *; }

# Location Services
-keep class com.google.android.gms.location.** { *; }
-dontwarn com.google.android.gms.location.**

# Flutter and plugins
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Your custom classes
-keep class com.crackersworld.android.LocationService { *; }
-keep class com.crackersworld.android.MainActivity { *; }