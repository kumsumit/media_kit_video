import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
    kotlin("android")
}

group = "com.alexmercerind.media_kit_video"
version = "1.0"

repositories {
    google()
    mavenCentral()
}

android {

    namespace = "com.alexmercerind.media_kit_video"

    compileSdk = 37

    defaultConfig {
        minSdk = 21
        consumerProguardFiles("proguard-rules.pro")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
}

kotlin {

    // JVM Toolchain (recommended for Kotlin 2.x)
    jvmToolchain(21)

    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_21)
    }
}