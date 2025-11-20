import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img_package;
import '../core/image_processing/image_processor.dart';
import '../core/data/models/print_settings.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';

class PhotoEditingPage extends StatefulWidget {
  final Uint8List? initialImage;

  const PhotoEditingPage({Key? key, this.initialImage}) : super(key: key);

  @override
  _PhotoEditingPageState createState() => _PhotoEditingPageState();
}

class _PhotoEditingPageState extends State<PhotoEditingPage> {
  Uint8List? _originalImage;
  Uint8List? _editedImage;
  double _threshold = 128.0;
  bool _invert = false;
  String _ditherAlgorithm = 'floyd-steinberg';
  double _rotationAngle = 0.0;
  double _scaleFactor = 1.0;
  
  final List<String> _algorithms = [
    'floyd-steinberg',
    'atkinson',
    'ordered',
    'halftone',
    'simple-threshold'
  ];

  @override
  void initState() {
    super.initState();
    _originalImage = widget.initialImage;
    if (_originalImage != null) {
      _applyEdits();
    }
  }

  Future<void> _selectNewImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _originalImage = imageBytes;
      });
      _applyEdits();
    }
  }

  Future<void> _captureNewImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _originalImage = imageBytes;
      });
      _applyEdits();
    }
  }

  void _applyEdits() {
    if (_originalImage == null) return;

    try {
      final imageProcessor = DefaultImageProcessor();
      final processedImage = imageProcessor.processImageFromBytes(
        _originalImage!,
        384, // Standard printer width
        ditherAlgorithm: _ditherAlgorithm,
        threshold: _threshold,
        invert: _invert,
      );

      // Convert back to image for display
      final image = _binaryImageToImage(processedImage);
      final encodedImage = img_package.encodePng(image);
      setState(() {
        _editedImage = Uint8List.fromList(encodedImage);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.photoEditor} $e')),
      );
    }
  }

  // Helper to convert binary image to displayable image
  img_package.Image _binaryImageToImage(List<List<bool>> binaryImage) {
    final image = img_package.Image(width: binaryImage[0].length, height: binaryImage.length);
    
    for (int y = 0; y < binaryImage.length; y++) {
      for (int x = 0; x < binaryImage[0].length; x++) {
        final color = binaryImage[y][x] ? img_package.ColorRgb8(0, 0, 0) : img_package.ColorRgb8(255, 255, 255);
        image.setPixel(x, y, color);
      }
    }
    
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.photoEditor),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Save edited image and return to previous page
              Navigator.pop(context, _originalImage);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Image preview
          if (_editedImage != null)
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: InteractiveViewer(
                child: Image.memory(_editedImage!, fit: BoxFit.contain),
              ),
            )
          else
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Text(AppLocalizations.of(context)!.photoEditor),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _selectNewImage,
                icon: const Icon(Icons.image),
                label: Text(AppLocalizations.of(context)!.photoGallery),
              ),
              ElevatedButton.icon(
                onPressed: _captureNewImage,
                icon: const Icon(Icons.camera_alt),
                label: Text(AppLocalizations.of(context)!.takePhoto),
              ),
              ElevatedButton.icon(
                onPressed: _originalImage != null ? _applyEdits : null,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Dither algorithm selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.ditherAlgorithm,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: _algorithms.map((algorithm) {
                      return ButtonSegment(
                        value: algorithm,
                        label: Text(algorithm.split('-').map((word) => 
                          word[0].toUpperCase() + word.substring(1)).join(' ')),
                      );
                    }).toList(),
                    selected: {_ditherAlgorithm},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _ditherAlgorithm = newSelection.first;
                      });
                      _applyEdits();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Threshold control
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.threshold,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _threshold,
                    min: 0.0,
                    max: 255.0,
                    divisions: 255,
                    label: _threshold.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _threshold = value;
                      });
                      _applyEdits();
                    },
                  ),
                  Text('Current value: ${_threshold.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Invert toggle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.threshold, // Using threshold as a placeholder
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _invert,
                    onChanged: (value) {
                      setState(() {
                        _invert = value;
                      });
                      _applyEdits();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Rotation control
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.imageRotation,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _rotationAngle,
                    min: 0.0,
                    max: 360.0,
                    divisions: 360,
                    label: _rotationAngle.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _rotationAngle = value;
                      });
                    },
                  ),
                  Text('Current value: ${_rotationAngle.round()}°'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Scale control
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.quality,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _scaleFactor,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: _scaleFactor.toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        _scaleFactor = value;
                      });
                    },
                  ),
                  Text('Current value: ${_scaleFactor.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Apply button
          ElevatedButton.icon(
            onPressed: _originalImage != null ? _applyEdits : null,
            icon: const Icon(Icons.auto_fix_high),
            label: Text(AppLocalizations.of(context)!.save),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}