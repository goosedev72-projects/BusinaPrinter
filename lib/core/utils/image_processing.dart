import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:dither_it/dither_it.dart';
import 'dart:ui' as ui;

class ImageProcessingService {
  /// Resize image to the printer width while maintaining aspect ratio
  static img.Image resizeImage(img.Image originalImage, int targetWidth, int maxHeight) {
    final scale = targetWidth / originalImage.width;
    final targetHeight = (originalImage.height * scale).round();
    
    // Limit height to prevent memory issues
    final height = maxHeight > 0 ? targetHeight.clamp(0, maxHeight) : targetHeight;
    
    return img.copyResize(originalImage, width: targetWidth, height: height);
  }

  /// Convert image to binary (black and white) format with dithering
  static List<List<bool>> convertToBinary(img.Image image, {String algorithm = 'floyd-steinberg', double threshold = 128.0}) {
    // Use the dither_it package for dithering
    final ditheredImg = _applyDitheringWithDitherIt(image, algorithm);
    
    final result = <List<bool>>[];
    
    // Calculate average brightness to use as adaptive threshold
    int totalBrightness = 0;
    int pixelCount = ditheredImg.width * ditheredImg.height;
    for (int y = 0; y < ditheredImg.height; y++) {
      for (int x = 0; x < ditheredImg.width; x++) {
        final pixel = ditheredImg.getPixel(x, y);
        // Use blue component for brightness calculation (similar to iPrint's approach)
        final b = pixel.b.toInt();
        totalBrightness += b;
      }
    }
    int avgBrightness = (totalBrightness / pixelCount).round();
    // Subtract 13 like iPrint does
    int adaptiveThreshold = avgBrightness - 13;
    
    for (int y = 0; y < ditheredImg.height; y++) {
      final row = <bool>[];
      
      for (int x = 0; x < ditheredImg.width; x++) {
        final pixel = ditheredImg.getPixel(x, y);
        final b = pixel.b.toInt(); // Using blue component like iPrint
        
        // Apply logic similar to iPrint: 
        // - if pixel is 0 (black), set to 1 (print black)
        // - if pixel > adaptiveThreshold, set to 0 (don't print - white)
        // - else, set to 1 (print black)
        bool isBlack;
        if (b == 0) {  // If pixel is pure black
          isBlack = true;  // Print as black
        } else if (b > adaptiveThreshold) {  // Brighter than threshold
          isBlack = false; // Don't print - appears white
        } else {  // Darker than threshold but not pure black
          isBlack = true;  // Print as black
        }
        
        row.add(isBlack);
      }
      
      result.add(row);
    }
    
    return result;
  }

  /// Apply dithering using dither_it package
  static img.Image _applyDitheringWithDitherIt(img.Image image, String algorithm) {
    // Apply dithering based on algorithm
    img.Image ditheredImage = image; // Default to original image if no algorithm matches
    
    switch (algorithm) {
      case 'floyd-steinberg':
        ditheredImage = DitherIt.floydSteinberg(image: image);
        break;
      case 'ordered':
        ditheredImage = DitherIt.ordered(image: image, matrixSize: 4);
        break;
      case 'riemersma':
        ditheredImage = DitherIt.riemersma(image: image, historySize: 16);
        break;
      default:
        // For other algorithms, fallback to Floyd-Steinberg
        ditheredImage = DitherIt.floydSteinberg(image: image);
        break;
    }
    
    return ditheredImage;
  }

  /// Convert image to binary with different dither algorithms
  static List<List<bool>> processImage(img.Image originalImage, int maxWidth,
      {String ditherAlgorithm = 'floyd-steinberg', double threshold = 128.0, bool invert = false, int spacerHeight = 0}) {
    // Step 1: Resize image to fit printer width
    final resizedImage = resizeImage(originalImage, maxWidth, 0);
    
    // Step 2: Apply dithering and binary conversion
    final binaryImage = convertToBinary(resizedImage, algorithm: ditherAlgorithm, threshold: threshold);
    
    // Step 3: Optionally invert the image
    if (invert) {
      for (int y = 0; y < binaryImage.length; y++) {
        for (int x = 0; x < binaryImage[0].length; x++) {
          binaryImage[y][x] = !binaryImage[y][x];
        }
      }
    }
    
    return binaryImage;
  }

  /// Process image from Uint8List data
  static List<List<bool>> processImageFromBytes(Uint8List imageBytes, int maxWidth,
      {String ditherAlgorithm = 'floyd-steinberg', double threshold = 128.0, bool invert = false, int spacerHeight = 0}) {
    final decodedImage = img.decodeImage(imageBytes)!;
    final processedImage = processImage(decodedImage, maxWidth, 
        ditherAlgorithm: ditherAlgorithm, 
        threshold: threshold, 
        invert: invert,
        spacerHeight: spacerHeight);
        
    // Add spacer after processing
    return _addSpacerToBinaryImage(processedImage, spacerHeight, maxWidth);
  }
  
  /// Preprocess an image for later printing (for image packs)
  static Future<Uint8List> preprocessImage(Uint8List imageBytes, int maxWidth,
      {String ditherAlgorithm = 'floyd-steinberg', double threshold = 128.0, bool invert = false, int energy = 0xffff, int spacerHeight = 0}) async {
    final binaryImage = processImageFromBytes(imageBytes, maxWidth,
        ditherAlgorithm: ditherAlgorithm, threshold: threshold, invert: invert, spacerHeight: spacerHeight);
    
    // Convert binary image to commands for later use
    final commands = <int>[];
    
    // Store preprocessing parameters as metadata
    final params = {
      'ditherAlgorithm': ditherAlgorithm,
      'threshold': threshold,
      'invert': invert,
      'energy': energy,
      'spacerHeight': spacerHeight,
    };
    
    // Encode the binary image data and metadata
    commands.addAll(utf8.encode(jsonEncode({
      'params': params,
      'image': _binaryImageToJson(binaryImage),
    })));
    
    return Uint8List.fromList(commands);
  }
  
  /// Helper to convert binary image to JSON format
  static List<List<int>> _binaryImageToJson(List<List<bool>> binaryImage) {
    return binaryImage.map((row) => row.map((pixel) => pixel ? 1 : 0).toList()).toList();
  }
  
  /// Helper to convert JSON format back to binary image
  static List<List<bool>> _jsonToBinaryImage(List<List<int>> jsonData) {
    return jsonData.map((row) => row.map((pixel) => pixel == 1).toList()).toList();
  }
  
  /// Helper to add spacer (white space) to the bottom of a binary image
  static List<List<bool>> _addSpacerToBinaryImage(List<List<bool>> binaryImage, int spacerHeight, int width) {
    if (spacerHeight <= 0) {
      return binaryImage; // No spacer needed
    }
    
    final result = List<List<bool>>.from(binaryImage);
    
    // Add empty (white) rows for the spacer
    for (int i = 0; i < spacerHeight; i++) {
      final spacerRow = List<bool>.filled(width, false); // false means white/no print
      result.add(spacerRow);
    }
    
    return result;
  }
}