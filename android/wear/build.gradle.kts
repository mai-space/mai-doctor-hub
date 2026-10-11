import java.util.Properties

// Uhr-App (Wear OS): Kachel, Komplikationen und kurze Übersicht.
// Zeigt den Snapshot der Startbildschirm-Widgets, den die Telefon-App per
// Google Play-Dienste (Data Layer, nur Nachrichten) schickt. Ohne eigene
// Datenbank, ohne INTERNET-Berechtigung.
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) keyPropertiesFile.inputStream().use { load(it) }
}

// Version wie die Telefon-App (Flutter schreibt sie beim Bauen nach
// local.properties). Der versionCode liegt um 1.000.000.000 höher, damit
// Telefon- und Uhr-APK im Play Store nie dieselbe Nummer haben.
val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val phoneVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val phoneVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

android {
    // Paket der App wie am Telefon (Pflicht für den Abgleich); eigener
    // Namespace nur für die generierte R-Klasse.
    namespace = "space.mai.mai_doctor_hub.wear"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "space.mai.mai_doctor_hub"
        // Wear OS 3 (API 30) und neuer.
        minSdk = 30
        targetSdk = 36
        versionCode = 1_000_000_000 + phoneVersionCode
        versionName = phoneVersionName
    }

    signingConfigs {
        if (keyPropertiesFile.exists()) {
            create("release") {
                // Pfad relativ zu android/app, wie in app/build.gradle.kts.
                storeFile = rootProject.file("app").resolve(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Gleicher Schlüssel wie die Telefon-App — sonst stellt der Data
            // Layer keine Nachrichten zu. Ohne key.properties: Debug-Key.
            signingConfig = signingConfigs.getByName(
                if (keyPropertiesFile.exists()) "release" else "debug",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // Kacheln (ProtoLayout) und Komplikationen.
    implementation("androidx.wear.tiles:tiles:1.4.1")
    implementation("androidx.wear.protolayout:protolayout:1.2.1")
    implementation("androidx.wear.watchface:watchface-complications-data-source-ktx:1.2.1")
    implementation("androidx.concurrent:concurrent-futures:1.2.0")
    // Abgleich mit dem Telefon (Nachrichten, keine DataItems).
    implementation("com.google.android.gms:play-services-wearable:19.0.0")
}
