# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep interface org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep interface org.tensorflow.lite.gpu.** { *; }

# Keep TensorFlow Lite GPU delegate
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory** { *; }
-keep class org.tensorflow.lite.gpu.CompatibilityList { *; }

# Keep Google ML Kit classes
-keep class com.google.mlkit.** { *; }
-keep interface com.google.mlkit.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }

# Keep Google Play Core classes (for app bundles and split features)
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Suppress warnings
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn org.tensorflow.lite.**
