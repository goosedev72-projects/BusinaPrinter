import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'printer_ble_service.dart';

class BlePrintingService {
  final PrinterBleService _bleService = PrinterBleService();
  
  bool get isConnected => _bleService.isConnected;

  /// Scan and connect to a printer device
  Future<bool> scanAndConnect(String? deviceName) async {
    try {
      // First find and connect to the device
      bool connected = await _bleService.findAndConnect(deviceName: deviceName);
      if (!connected) {
        return false;
      }
      
      // Then discover the printer service and characteristics
      bool serviceDiscovered = await _bleService.discoverPrinterService();
      if (!serviceDiscovered) {
        await _bleService.disconnect();
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ BLE connection error: $e');
      return false;
    }
  }

  /// Send print commands to the printer
  Future<bool> sendPrintCommands(List<int> commands) async {
    return await _bleService.sendPrintCommands(commands);
  }

  /// Disconnect from printer
  Future<void> disconnect() async {
    await _bleService.disconnect();
  }

  /// Get printer state information
  Future<Map<String, dynamic>?> getPrinterState() async {
    return await _bleService.getPrinterState();
  }

  /// Get printer info
  Future<Map<String, dynamic>?> getPrinterInfo() async {
    return await _bleService.getPrinterInfo();
  }
}