import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../utils/image_processing.dart';

/// Interface for image processing operations
abstract class ImageProcessor {
  /// Process an image from bytes
  List<List<bool>> processImageFromBytes(
    Uint8List imageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  });

  /// Process a rotated text image
  List<List<bool>> processRotatedText(
    Uint8List textImageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  });

  /// Process a rotated image
  List<List<bool>> processRotatedImage(
    Uint8List imageBytes,
    double rotationAngle,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  });

  /// Preprocess an image for later printing
  Future<Uint8List> preprocessImage(
    Uint8List imageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int energy = 0xffff,
    int spacerHeight = 0,
  });
}

/// Default implementation of ImageProcessor
class DefaultImageProcessor implements ImageProcessor {
  @override
  List<List<bool>> processImageFromBytes(
    Uint8List imageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  }) {
    return ImageProcessingService.processImageFromBytes(
      imageBytes,
      maxWidth,
      ditherAlgorithm: ditherAlgorithm ?? 'floyd-steinberg',
      threshold: threshold,
      invert: invert,
      spacerHeight: spacerHeight,
    );
  }

  @override
  List<List<bool>> processRotatedText(
    Uint8List textImageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  }) {
    final decodedImage = img.decodeImage(textImageBytes);
    if (decodedImage == null) {
      throw Exception('Could not decode text image');
    }

    // Rotate the image by 90 degrees
    final rotatedImage = img.copyRotate(decodedImage, angle: 90);

    return ImageProcessingService.processImage(
      rotatedImage,
      maxWidth,
      ditherAlgorithm: ditherAlgorithm ?? 'floyd-steinberg',
      threshold: threshold,
      invert: invert,
      spacerHeight: spacerHeight,
    );
  }

  @override
  List<List<bool>> processRotatedImage(
    Uint8List imageBytes,
    double rotationAngle,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int spacerHeight = 0,
  }) {
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw Exception('Could not decode image');
    }

    // Rotate the image
    final rotatedImage = img.copyRotate(decodedImage, angle: rotationAngle.round());

    return ImageProcessingService.processImage(
      rotatedImage,
      maxWidth,
      ditherAlgorithm: ditherAlgorithm ?? 'floyd-steinberg',
      threshold: threshold,
      invert: invert,
      spacerHeight: spacerHeight,
    );
  }

  @override
  Future<Uint8List> preprocessImage(
    Uint8List imageBytes,
    int maxWidth, {
    String? ditherAlgorithm,
    double threshold = 128.0,
    bool invert = false,
    int energy = 0xffff,
    int spacerHeight = 0,
  }) async {
    return await ImageProcessingService.preprocessImage(
      imageBytes,
      maxWidth,
      ditherAlgorithm: ditherAlgorithm ?? 'floyd-steinberg',
      threshold: threshold,
      invert: invert,
      energy: energy,
      spacerHeight: spacerHeight,
    );
  }
}