import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';

/// A service class specifically for thermal printer BLE operations
class PrinterBleService {
  static const List<String> POSSIBLE_SERVICE_UUIDS = [
    "0000ae30-0000-1000-8000-00805f9b34fb",
    "0000af30-0000-1000-8000-00805f9b34fb",
  ];
  static const String TX_CHARACTERISTIC_UUID = "0000ae01-0000-1000-8000-00805f9b34fb";
  static const String RX_CHARACTERISTIC_UUID = "0000ae02-0000-1000-8000-00805f9b34fb";

  static const List<int> PRINTER_READY_NOTIFICATION = [0x51, 0x78, 0xae, 0x01, 0x01, 0x00, 0x00, 0x00, 0xff];
  static const int SCAN_TIMEOUT_S = 15;
  static const int WAIT_AFTER_EACH_CHUNK_S = 20; // 20ms

  BleDevice? _connectedDevice;
  StreamSubscription<Uint8List>? _rxNotificationSubscription;
  String? _connectedDeviceId;
  int _mtu = 23; // Default MTU size
  bool _isConnected = false;
  final List<Function(Uint8List data)> _notificationCallbacks = [];
  
  bool get isConnected => _isConnected;
  String? get connectedDeviceId => _connectedDeviceId;

  /// Add a callback to be notified when printer notifications are received
  void addNotificationCallback(Function(Uint8List data) callback) {
    _notificationCallbacks.add(callback);
  }

  /// Remove a notification callback
  void removeNotificationCallback(Function(Uint8List data) callback) {
    _notificationCallbacks.remove(callback);
  }

  /// Find and connect to a thermal printer
  Future<bool> findAndConnect({
    String? deviceName,
    int timeoutSeconds = SCAN_TIMEOUT_S,
  }) async {
    try {
      debugPrint('🔍 Scanning for thermal printers...');
      
      // Check if runtime permissions are required and handle them appropriately
      if (BleCapabilities.requiresRuntimePermission) {
        debugPrint('Runtime permissions required for this platform');
        // In a real app, you would implement permission handling here
        // For now, we'll just continue assuming permissions are granted
      }
      
      // Set up connection change listener
      UniversalBle.onConnectionChange = (deviceId, isConnected, error) {
        if (deviceId == _connectedDeviceId) {
          debugPrint('Connection status changed for ${deviceId}: ${isConnected ? "Connected" : "Disconnected"}');
          _isConnected = isConnected;
        }
      };
      
      // Start scanning for devices with the expected service UUIDs
      await UniversalBle.startScan(
        scanFilter: ScanFilter(
          withServices: POSSIBLE_SERVICE_UUIDS,
        ),
      );
      
      Completer<BleDevice> deviceCompleter = Completer<BleDevice>();
      late StreamSubscription<BleDevice> scanSubscription;
      
      scanSubscription = UniversalBle.scanStream.listen(
        (BleDevice device) {
          debugPrint('Found device: ${device.name} (${device.deviceId})');
          
          // Look for devices with the expected service UUIDs or matching name patterns
          bool hasExpectedService = device.services.any((service) => 
              POSSIBLE_SERVICE_UUIDS.any((expected) => 
                  service.toLowerCase() == expected.toLowerCase()));
          
          bool matchesNamePattern = deviceName != null && 
              device.name != null && 
              device.name!.toLowerCase().contains(deviceName.toLowerCase());
              
          bool hasGenericName = device.name != null && 
              (device.name!.toLowerCase().contains('gt') || 
               device.name!.toLowerCase().contains('gb') ||
               device.name!.toLowerCase().contains('printer') ||
               device.name!.toLowerCase().contains('thermal'));
          
          if (hasExpectedService || matchesNamePattern || hasGenericName) {
            debugPrint('✅ Found potential thermal printer: ${device.name} (${device.deviceId})');
            scanSubscription.cancel();
            UniversalBle.stopScan();
            deviceCompleter.complete(device);
          }
        },
        onError: (error) {
          debugPrint('Scan error: $error');
          if (!deviceCompleter.isCompleted) {
            deviceCompleter.completeError(error);
          }
        },
      );
      
      // Set timeout for device discovery
      Timer(Duration(seconds: timeoutSeconds), () {
        if (!deviceCompleter.isCompleted) {
          scanSubscription.cancel();
          UniversalBle.stopScan();
          deviceCompleter.completeError('Scan timeout: No printer found within $timeoutSeconds seconds');
        }
      });
      
      // Wait for a device to be found or timeout
      BleDevice device = await deviceCompleter.future;
      _connectedDevice = device;
      _connectedDeviceId = device.deviceId;
      
      debugPrint('✅ Found printer: ${device.name} (${device.deviceId})');

      // Connect to the device
      debugPrint('🔌 Connecting to ${device.deviceId}...');
      await UniversalBle.connect(device.deviceId, timeout: Duration(seconds: 15));
      
      // Wait for connection to be established
      int attempts = 0;
      while (!_isConnected && attempts < 10) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }
      
      if (!_isConnected) {
        throw Exception('Failed to establish connection with printer');
      }
      
      debugPrint('✅ Successfully connected to thermal printer');
      return true;
    } catch (e) {
      debugPrint('❌ BLE connection error: $e');
      _isConnected = false;
      await _cleanupConnection();
      return false;
    }
  }

  /// Discover printer service and characteristics
  Future<bool> discoverPrinterService() async {
    if (!isConnected || _connectedDeviceId == null) {
      debugPrint('❌ Not connected to any device');
      return false;
    }

    try {
      debugPrint('🔍 Discovering printer service and characteristics...');
      
      // Discover services
      List<BleService> services = await UniversalBle.discoverServices(_connectedDeviceId!);
      debugPrint('Discovered ${services.length} services');
      
      // Find the service with the expected UUIDs
      BleService? printerService;
      for (BleService service in services) {
        for (String uuid in POSSIBLE_SERVICE_UUIDS) {
          if (BleUuidParser.compareStrings(service.uuid, uuid)) {
            printerService = service;
            break;
          }
        }
        if (printerService != null) break;
      }
      
      if (printerService == null) {
        throw Exception('Printer service not found. Available services: ${services.map((s) => s.uuid).toList()}');
      }
      
      debugPrint('✅ Found printer service: ${printerService.uuid}');
      
      // Request MTU to optimize data transfer
      try {
        _mtu = await UniversalBle.requestMtu(_connectedDeviceId!, 512);
        debugPrint('✅ MTU set to: $_mtu');
      } catch (e) {
        debugPrint('⚠️ Could not set MTU, using default: $_mtu - Error: $e');
        // Try to use a more reasonable default if the MTU request failed
        // Some printers work better with MTU of 245-247
        _mtu = 245; // Use a reasonable default for thermal printers
        debugPrint('Using fallback MTU: $_mtu');
      }
      
      // Set up notification listener if RX characteristic is available
      await _setupNotificationListener(printerService);
      
      debugPrint('✅ Printer service and characteristics discovered successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error discovering printer service: $e');
      return false;
    }
  }

  /// Set up notification listener for printer responses
  Future<void> _setupNotificationListener(BleService printerService) async {
    // Find RX characteristic for notifications
    BleCharacteristic? rxCharacteristic;
    for (BleCharacteristic characteristic in printerService.characteristics) {
      if (BleUuidParser.compareStrings(characteristic.uuid, RX_CHARACTERISTIC_UUID)) {
        rxCharacteristic = characteristic;
        break;
      }
    }
    
    if (rxCharacteristic != null) {
      debugPrint('✅ Setting up notification listener for: ${rxCharacteristic.uuid}');
      
      // Subscribe to notifications
      await UniversalBle.subscribeNotifications(
        _connectedDeviceId!,
        printerService.uuid,
        rxCharacteristic.uuid,
      );
      
      // Listen to characteristic value stream
      _rxNotificationSubscription = UniversalBle.characteristicValueStream(
        _connectedDeviceId!,
        rxCharacteristic.uuid,
      ).listen(
        _handleNotification,
        onError: (error) {
          debugPrint('RX notification stream error: $error');
        },
      );
      
      // Set up global value change callback
      UniversalBle.onValueChange = (deviceId, characteristicId, value) {
        if (deviceId == _connectedDeviceId && 
            rxCharacteristic != null && 
            BleUuidParser.compareStrings(characteristicId, rxCharacteristic!.uuid)) {
          _handleNotification(value);
        }
      };
    } else {
      debugPrint('⚠️ RX characteristic not found, notifications may not be available');
    }
  }

  /// Handle printer notifications
  void _handleNotification(Uint8List data) {
    debugPrint('📡 Received notification from printer: ${data.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}');
    
    // Call all registered notification callbacks
    for (var callback in _notificationCallbacks) {
      try {
        callback(data);
      } catch (e) {
        debugPrint('Error in notification callback: $e');
      }
    }
    
    // Handle specific printer ready notification
    if (_isPrinterReadyNotification(data)) {
      debugPrint('✅ Printer is ready!');
      // Implement any printer-ready logic here if needed
    }
  }
  
  /// Check if the received data is a printer ready notification
  bool _isPrinterReadyNotification(Uint8List data) {
    if (data.length != PRINTER_READY_NOTIFICATION.length) {
      return false;
    }
    
    for (int i = 0; i < data.length; i++) {
      if (data[i] != PRINTER_READY_NOTIFICATION[i]) {
        return false;
      }
    }
    
    return true;
  }

  /// Send print commands to the printer
  Future<bool> sendPrintCommands(List<int> commands) async {
    if (!isConnected || _connectedDeviceId == null) {
      throw Exception('Not connected to printer');
    }

    try {
      // Instead of blindly chunking the data, we should respect command boundaries
      // The original chunking might break command structures in the middle
      final chunks = _smartChunkify(commands, _mtu - 3); // Allow 3 bytes for overhead
      
      debugPrint('📤 Sending ${commands.length} bytes in ${chunks.length} chunks');
      
      for (int i = 0; i < chunks.length; i++) {
        final chunk = Uint8List.fromList(chunks[i]);
        
        // Write the chunk to the TX characteristic
        await UniversalBle.write(
          _connectedDeviceId!,
          POSSIBLE_SERVICE_UUIDS[0], // Use first possible service UUID
          TX_CHARACTERISTIC_UUID,
          chunk,
          withoutResponse: true,
        );
        
        debugPrint('📤 Sent chunk $i: ${chunk.length} bytes');
        
        // Small delay between chunks to allow printer to process
        await Future.delayed(Duration(milliseconds: WAIT_AFTER_EACH_CHUNK_S));
      }
      
      debugPrint('✅ Successfully sent print commands');
      return true;
    } catch (e) {
      debugPrint('❌ Error sending print commands: $e');
      return false;
    }
  }
  
  /// Split data into chunks intelligently to respect command boundaries when possible
  List<List<int>> _smartChunkify(List<int> data, int chunkSize) {
    // For now, use the simple approach, but with a larger effective chunk size if possible
    // In the future, we could implement logic to identify command boundaries
    // and make sure not to split mid-command
    final chunks = <List<int>>[];
    for (int i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, data.length);
      chunks.add(data.sublist(i, end));
    }
    return chunks;
  }
  
  /// Split data into chunks (legacy method)
  List<List<int>> _chunkify(List<int> data, int chunkSize) {
    final chunks = <List<int>>[];
    for (int i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, data.length);
      chunks.add(data.sublist(i, end));
    }
    return chunks;
  }

  /// Get printer state information
  Future<Map<String, dynamic>?> getPrinterState() async {
    if (!isConnected || _connectedDeviceId == null) {
      debugPrint('⚠️ Not connected to printer');
      return null;
    }
    
    try {
      // Send command to get printer state
      await UniversalBle.write(
        _connectedDeviceId!,
        POSSIBLE_SERVICE_UUIDS[0],
        TX_CHARACTERISTIC_UUID,
        Uint8List.fromList([0x51, 0x78, 0xa3, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff]),
        withoutResponse: true,
      );
      
      return {'success': true, 'message': 'Printer state query sent'};
    } catch (e) {
      debugPrint('❌ Error getting printer state: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get printer info
  Future<Map<String, dynamic>?> getPrinterInfo() async {
    if (!isConnected || _connectedDeviceId == null) {
      debugPrint('⚠️ Not connected to printer');
      return null;
    }
    
    try {
      // Send command to get printer info
      await UniversalBle.write(
        _connectedDeviceId!,
        POSSIBLE_SERVICE_UUIDS[0],
        TX_CHARACTERISTIC_UUID,
        Uint8List.fromList([0x51, 0x78, 0x78, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff]),
        withoutResponse: true,
      );
      
      return {'success': true, 'message': 'Printer info query sent'};
    } catch (e) {
      debugPrint('❌ Error getting printer info: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Disconnect from printer
  Future<void> disconnect() async {
    await _cleanupConnection();
  }
  
  /// Internal method to clean up connection
  Future<void> _cleanupConnection() async {
    try {
      if (_connectedDeviceId != null) {
        await UniversalBle.disconnect(_connectedDeviceId!);
      }
      
      await _rxNotificationSubscription?.cancel();
      _rxNotificationSubscription = null;
      _connectedDevice = null;
      _connectedDeviceId = null;
      _isConnected = false;
      _notificationCallbacks.clear();
      
      debugPrint('🔌 Disconnected from printer');
    } catch (e) {
      debugPrint('Error during disconnect: $e');
    }
  }
}