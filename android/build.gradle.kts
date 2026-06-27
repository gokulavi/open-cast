// ============================================================
// android/build.gradle.kts  (ROOT — not app/build.gradle.kts)
// ============================================================

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Use AGP 8.1.x — stable with Flutter 3.x + Agora
        classpath("com.android.tools.build:gradle:8.1.4")
        // ✅ Google Services for Firebase
        classpath("com.google.gms:google-services:4.4.1")
        // Kotlin gradle plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        // Needed for some Flutter plugins
        maven { url = uri("https://jitpack.io") }
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}