plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin do Flutter deve vir por último
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pizza_order_app"
    compileSdk = flutter.compileSdkVersion

    // ✅ Corrigido: define versão correta do NDK
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.pizza_order_app"
        minSdk = 21 //
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

flutter {
    source = "../.."
}
