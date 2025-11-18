import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_package;


class TextToImageService {
  /// Convert text to a printable image
  static Future<Uint8List> convertTextToImage(
    String text, {
    double fontSize = 24.0,
    Color textColor = const Color(0xFF000000),
    Color backgroundColor = const Color(0xFFFFFFFF),
    double padding = 16.0,
    String fontFamily = 'Roboto',
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
  }) async {
    // Use a higher resolution scale factor to improve text quality
    const double scale = 2.0; // Double the resolution
    
    // Measure text to determine required canvas size at normal scale
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate canvas size at high resolution
    final normalWidth = (textPainter.width + padding * 2).ceil();
    final normalHeight = (textPainter.height + padding * 2).ceil();
    final width = (normalWidth * scale).ceil();
    final height = (normalHeight * scale).ceil();
    final scaledPadding = padding * scale;
    
    // Create and render the text to an image at higher resolution
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    // Fill background
    Paint bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bgPaint);
    
    // Draw text at higher resolution
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize * scale,
        color: textColor,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
    );
    final textPainterForCanvas = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainterForCanvas.layout();
    textPainterForCanvas.paint(canvas, Offset(scaledPadding, scaledPadding));
    
    // Get the picture and convert to image
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData == null) {
      throw Exception('Could not convert text to image');
    }
    
    // Convert back to normal size to maintain proper proportions
    final rawBytes = byteData.buffer.asUint8List();
    final originalImage = img_package.decodeImage(rawBytes);
    if (originalImage == null) {
      throw Exception('Could not decode rendered image');
    }
    
    // Resize back to original dimensions (to maintain quality but at proper size)
    final resizedImage = img_package.copyResize(originalImage, 
      width: normalWidth, 
      height: normalHeight,
      interpolation: img_package.Interpolation.average
    );
    
    final encodedImage = img_package.encodePng(resizedImage);
    return Uint8List.fromList(encodedImage);
  }
  
  /// Convert long text to multiple lines and create a long vertical image
  static Future<Uint8List> convertLongTextToImage(
    String text, {
    double fontSize = 18.0,
    Color textColor = const Color(0xFF000000),
    Color backgroundColor = const Color(0xFFFFFFFF),
    double padding = 16.0,
    double maxWidth = 384.0, // Standard printer width
    String fontFamily = 'Roboto',
  }) async {
    // Use a higher resolution scale factor to improve text quality
    const double scale = 2.0; // Double the resolution
    
    // Split the text into lines that fit within the max scaled width
    final scaledMaxWidth = maxWidth * scale;
    final scaledPadding = padding * scale;
    final scaledFontSize = fontSize * scale;
    
    // Split the text into lines that fit within the max width
    final lines = _wrapText(text, scaledFontSize, fontFamily, scaledMaxWidth - scaledPadding * 2);
    
    // Create individual line images at higher resolution
    final lineImages = <img_package.Image>[];
    
    for (final line in lines) {
      // Render individual lines at higher resolution
      final textPainter = TextPainter(
        text: TextSpan(
          text: line,
          style: TextStyle(
            fontSize: scaledFontSize,
            color: textColor,
            fontFamily: fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final width = (textPainter.width + scaledPadding * 2).ceil();
      final height = (textPainter.height + scaledPadding * 2).ceil();
      
      // Create and render the text to an image at higher resolution
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      
      // Fill background
      Paint bgPaint = Paint()..color = backgroundColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bgPaint);
      
      // Draw text at higher resolution
      final textSpan = TextSpan(
        text: line,
        style: TextStyle(
          fontSize: scaledFontSize,
          color: textColor,
          fontFamily: fontFamily,
        ),
      );
      final textPainterForCanvas = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainterForCanvas.layout();
      textPainterForCanvas.paint(canvas, Offset(scaledPadding, scaledPadding));
      
      // Get the picture and convert to image
      final picture = pictureRecorder.endRecording();
      final img = await picture.toImage(width, height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('Could not convert line to image');
      }
      
      final rawImage = img_package.decodeImage(byteData.buffer.asUint8List());
      if (rawImage != null) {
        // Resize back to proper dimensions for final result
        final resizedLineImage = img_package.copyResize(rawImage, 
          width: (rawImage.width / scale).round(), 
          height: (rawImage.height / scale).round(),
          interpolation: img_package.Interpolation.average
        );
        lineImages.add(resizedLineImage);
      }
    }
    
    if (lineImages.isEmpty) {
      throw Exception('Could not create any line images');
    }
    
    // Combine all line images into a single long image at normal resolution
    final totalHeight = lineImages.fold(0, (sum, img) => sum + img.height);
    final combinedImage = img_package.Image(
      width: lineImages.first.width,
      height: totalHeight,
    );
    
    // Fill with background color
    img_package.fill(combinedImage, color: img_package.ColorRgba8(255, 255, 255, 255));
    
    // Paste each line image
    int currentY = 0;
    for (final lineImage in lineImages) {
      // Properly draw the line image onto the combined image at the correct position
      img_package.compositeImage(combinedImage, lineImage, 
        srcX: 0, srcY: 0, 
        dstX: 0, dstY: currentY);
      currentY += lineImage.height;
    }
    
    // Encode the combined image
    final encodedImage = img_package.encodePng(combinedImage);
    return Uint8List.fromList(encodedImage);
  }
  
  /// Wrap text to fit within a specified width
  static List<String> _wrapText(String text, double fontSize, String fontFamily, double maxWidth) {
    final words = text.split(' ');
    final lines = <String>[];
    String currentLine = '';
    
    for (final word in words) {
      // Check if adding the next word would exceed the width
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';
      
      // This is a simplified width calculation - in a real application,
      // you would use Flutter's text metrics to get actual width
      // Here we'll use an approximation based on character count and font size
      if (_approximateTextWidth(testLine, fontSize) > maxWidth) {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = word;
        } else {
          // If a single word is too long, we'll add it as is
          lines.add(word);
          currentLine = '';
        }
      } else {
        currentLine = testLine;
      }
    }
    
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }
    
    return lines;
  }
  
  /// Approximate text width (simplified calculation)
  static double _approximateTextWidth(String text, double fontSize) {
    // This is a very rough approximation
    // In a real application, use Flutter's text measurement
    return text.length * fontSize * 0.6; // Approximate character width factor
  }
}