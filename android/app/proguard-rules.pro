# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep BLE-related classes
-keep class android.bluetooth.** { *; }
-keep class android.bluetooth.le.** { *; }

# Keep universal_ble plugin classes
-keep class **.universal_ble.** { *; }
-keep class io.github.ponnamkarthik.** { *; }

# Keep BleManager and related classes from the universal_ble plugin
-keep class **.BleManager { *; }
-keep class **.BleScanner { *; }
-keep class **.BleDevice { *; }
-keep class **.BleStatus { *; }
-keep class **.BleScanResult { *; }
-keep class **.BleScanOptions { *; }
-keep class **.BleService { *; }
-keep class **.BleCharacteristic { *; }

# Keep GATT related classes
-keep class android.bluetooth.BluetoothGatt { *; }
-keep class android.bluetooth.BluetoothGattCallback { *; }
-keep class android.bluetooth.BluetoothGattService { *; }
-keep class android.bluetooth.BluetoothGattCharacteristic { *; }
-keep class android.bluetooth.BluetoothGattDescriptor { *; }

# Suppress warnings related to the universal_ble plugin
-dontwarn io.github.ponnamkarthik.different_**

# Keep methods that might be accessed by the native side
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep the FlutterApplication class
-keep class **.FlutterApplication { *; }

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep annotations
-keep class * extends java.lang.annotation.Annotation { *; }

# Google Play Core library rules (for Flutter)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep methods that might be accessed by the native side
-keepclasseswithmembernames class * {
    native <methods>;
}