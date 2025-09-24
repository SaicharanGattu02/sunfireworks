plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.crackersworld.android"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            keyAlias = "upload"
            keyPassword = "sunfireworks"
            storePassword = "sunfireworks"
            storeFile = file("D:\\sunfireworks\\android\\app\\upload-keystore.jks")
        }
    }

    defaultConfig {
        applicationId = "com.crackersworld.android"
        minSdkVersion(24) // Correct function syntax
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

repositories {
    google()
    mavenCentral()
    maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
}

dependencies {
    // Google Play Services Location
    implementation("com.google.android.gms:play-services-location:21.3.0")

    // WorkManager (only keep if you actually use it)
    implementation("androidx.work:work-runtime:2.9.1")

    // Retrofit + OkHttp
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    // Coroutines (REQUIRED for your LocationService)
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")

    // Android KTX (handy extensions, recommended)
    implementation("androidx.core:core-ktx:1.13.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
