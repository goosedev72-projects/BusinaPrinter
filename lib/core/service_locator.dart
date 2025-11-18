import 'printing/printer_service.dart';
import 'image_processing/image_processor.dart';
import 'ble/ble_printing_service.dart';
import 'data/image_pack_repository.dart';
import 'data/default_image_pack_repository.dart';

/// Dependency injection container for the app
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Singleton services
  PrinterService? _printerService;
  ImagePackRepository? _imagePackRepository;

  /// Get the PrinterService instance
  PrinterService getPrinterService() {
    return _printerService ??= PrinterService(
      bleService: BlePrintingService(),
      imageProcessor: DefaultImageProcessor(),
    );
  }

  /// Get the ImagePackRepository instance
  ImagePackRepository getImagePackRepository() {
    return _imagePackRepository ??= DefaultImagePackRepository();
  }

  /// Clear all services (useful for testing)
  void reset() {
    _printerService = null;
    _imagePackRepository = null;
  }
}