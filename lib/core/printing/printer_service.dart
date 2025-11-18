import 'dart:typed_data';
import '../ble/ble_printing_service.dart';
import '../image_processing/image_processor.dart';
import '../utils/ble_commands.dart';
import '../utils/text_to_image_service.dart';
import '../data/models/print_settings.dart';
import '../data/models/image_pack.dart';

/// Main service that orchestrates all printing functionality
class PrinterService {
  final BlePrintingService _bleService;
  final ImageProcessor _imageProcessor;

  PrinterService({
    BlePrintingService? bleService,
    ImageProcessor? imageProcessor,
  })  : _bleService = bleService ?? BlePrintingService(),
        _imageProcessor = imageProcessor ?? DefaultImageProcessor();

  /// Get connected status
  bool get isConnected => _bleService.isConnected;

  /// Connect to printer
  Future<bool> connectToPrinter({String? deviceName}) async {
    return await _bleService.scanAndConnect(deviceName);
  }

  /// Disconnect from printer
  Future<void> disconnectFromPrinter() async {
    await _bleService.disconnect();
  }

  /// Print an image with specified settings
  Future<bool> printImage(Uint8List imageBytes, {PrintSettings? settings}) async {
    try {
      final effectiveSettings = settings ?? PrintSettings();
      final processedImage = _imageProcessor.processImageFromBytes(
        imageBytes,
        BleCommands.PRINT_WIDTH,
        ditherAlgorithm: effectiveSettings.ditherAlgorithm,
        threshold: effectiveSettings.threshold,
        invert: effectiveSettings.invert,
        spacerHeight: effectiveSettings.spacerHeight,
      );
      
      final commands = BleCommands.generatePrintCommands(processedImage, energy: effectiveSettings.energyLevel);
      
      // Print multiple copies if specified
      final copies = effectiveSettings.copies > 0 ? effectiveSettings.copies : 1;
      
      for (int i = 0; i < copies; i++) {
        final success = await _bleService.sendPrintCommands(commands);
        if (!success) {
          return false;
        }
        
        // Small delay between copies to allow printer to process
        if (i < copies - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      return true;
    } catch (e) {
      print('Error printing image: $e');
      return false;
    }
  }

  /// Print text with specified settings
  Future<bool> printText(String text, {PrintSettings? settings}) async {
    try {
      final effectiveSettings = settings ?? PrintSettings();
      
      final textImageBytes = await TextToImageService.convertLongTextToImage(
        text,
        fontSize: 18.0,
        maxWidth: 384.0,
      );
      
      final processedImage = _imageProcessor.processImageFromBytes(
        textImageBytes,
        384,
        ditherAlgorithm: effectiveSettings.ditherAlgorithm,
        threshold: effectiveSettings.threshold,
        invert: effectiveSettings.invert,
        spacerHeight: effectiveSettings.spacerHeight,
      );
      
      final commands = BleCommands.generatePrintCommands(processedImage, energy: effectiveSettings.energyLevel);
      
      // Print multiple copies if specified
      final copies = effectiveSettings.copies > 0 ? effectiveSettings.copies : 1;
      
      for (int i = 0; i < copies; i++) {
        final success = await _bleService.sendPrintCommands(commands);
        if (!success) {
          return false;
        }
        
        // Small delay between copies to allow printer to process
        if (i < copies - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      return true;
    } catch (e) {
      print('Error printing text: $e');
      return false;
    }
  }

  /// Print rotated text with specified settings
  Future<bool> printRotatedText(String text, {PrintSettings? settings}) async {
    try {
      final effectiveSettings = settings ?? PrintSettings();
      
      final textImageBytes = await TextToImageService.convertLongTextToImage(
        text,
        fontSize: 18.0,
        maxWidth: 384.0,
      );
      
      final processedImage = _imageProcessor.processRotatedText(
        textImageBytes,
        384,
        ditherAlgorithm: effectiveSettings.ditherAlgorithm,
        threshold: effectiveSettings.threshold,
        invert: effectiveSettings.invert,
        spacerHeight: effectiveSettings.spacerHeight,
      );
      
      final commands = BleCommands.generatePrintCommands(processedImage, energy: effectiveSettings.energyLevel);
      
      // Print multiple copies if specified
      final copies = effectiveSettings.copies > 0 ? effectiveSettings.copies : 1;
      
      for (int i = 0; i < copies; i++) {
        final success = await _bleService.sendPrintCommands(commands);
        if (!success) {
          return false;
        }
        
        // Small delay between copies to allow printer to process
        if (i < copies - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      return true;
    } catch (e) {
      print('Error printing rotated text: $e');
      return false;
    }
  }

  /// Print rotated image with specified settings
  Future<bool> printImageRotated(Uint8List imageBytes, {double rotationAngle = 90.0, PrintSettings? settings}) async {
    try {
      final effectiveSettings = settings ?? PrintSettings();
      
      final processedImage = _imageProcessor.processRotatedImage(
        imageBytes,
        rotationAngle,
        BleCommands.PRINT_WIDTH,
        ditherAlgorithm: effectiveSettings.ditherAlgorithm,
        threshold: effectiveSettings.threshold,
        invert: effectiveSettings.invert,
        spacerHeight: effectiveSettings.spacerHeight,
      );
      
      final commands = BleCommands.generatePrintCommands(processedImage, energy: effectiveSettings.energyLevel);
      
      // Print multiple copies if specified
      final copies = effectiveSettings.copies > 0 ? effectiveSettings.copies : 1;
      
      for (int i = 0; i < copies; i++) {
        final success = await _bleService.sendPrintCommands(commands);
        if (!success) {
          return false;
        }
        
        // Small delay between copies to allow printer to process
        if (i < copies - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      return true;
    } catch (e) {
      print('Error printing rotated image: $e');
      return false;
    }
  }

  /// Print a preprocessed image from an image pack
  Future<bool> printPreprocessedImage(Uint8List preprocessedImageBytes, {int copies = 1}) async {
    if (!_bleService.isConnected) {
      print('Printer not connected');
      return false;
    }

    try {
      for (int i = 0; i < copies; i++) {
        final success = await _bleService.sendPrintCommands(List.from(preprocessedImageBytes));
        if (!success) {
          return false;
        }
        
        if (i < copies - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      
      return true;
    } catch (e) {
      print('Error printing preprocessed image: $e');
      return false;
    }
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