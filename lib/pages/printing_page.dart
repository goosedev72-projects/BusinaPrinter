import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_package;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../core/printing/printer_service.dart';
import '../core/service_locator.dart';
import '../core/data/models/print_settings.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';

class PrintingPage extends StatefulWidget {
  final Function(Locale) changeLocaleCallback;

  const PrintingPage({Key? key, required this.changeLocaleCallback}) : super(key: key);

  @override
  _PrintingPageState createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  final PrinterService _printerService = ServiceLocator().getPrinterService();
  Uint8List? _selectedImage;
  String? _selectedText;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isConnected = _printerService.isConnected;
    });
  }

  Future<void> _selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = imageBytes;
          _selectedText = null;
        });
      }
    } catch (e) {
      print('${AppLocalizations.of(context)!.photoGallery} $e');
    }
  }



  Future<void> _captureImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = imageBytes;
          _selectedText = null;
        });
      }
    } catch (e) {
      print('${AppLocalizations.of(context)!.takePhoto} $e');
    }
  }

  Future<void> _printSelectedImage() async {
    if (_selectedImage == null) {
      _showSnackBar(AppLocalizations.of(context)!.photoGallery);
      return;
    }

    if (!_printerService.isConnected) {
      _showSnackBar(AppLocalizations.of(context)!.printerNotConnected);
      return;
    }

    _showSnackBar(AppLocalizations.of(context)!.printing);
    final success = await _printerService.printImage(_selectedImage!);
    if (success) {
      _showSnackBar(AppLocalizations.of(context)!.printComplete);
    } else {
      _showSnackBar(AppLocalizations.of(context)!.printFailed);
    }
  }

  Future<void> _printText() async {
    if (_selectedText == null || _selectedText!.isEmpty) {
      _showSnackBar(AppLocalizations.of(context)!.enterText);
      return;
    }

    if (!_printerService.isConnected) {
      _showSnackBar(AppLocalizations.of(context)!.printerNotConnected);
      return;
    }

    _showSnackBar(AppLocalizations.of(context)!.printing);
    final success = await _printerService.printText(_selectedText!);
    if (success) {
      _showSnackBar(AppLocalizations.of(context)!.printComplete);
    } else {
      _showSnackBar(AppLocalizations.of(context)!.printFailed);
    }
  }
  
  Future<void> _printRotatedText() async {
    if (_selectedText == null || _selectedText!.isEmpty) {
      _showSnackBar(AppLocalizations.of(context)!.enterText);
      return;
    }

    if (!_printerService.isConnected) {
      _showSnackBar(AppLocalizations.of(context)!.printerNotConnected);
      return;
    }

    _showSnackBar(AppLocalizations.of(context)!.printing);
    final success = await _printerService.printRotatedText(_selectedText!);
    if (success) {
      _showSnackBar(AppLocalizations.of(context)!.printComplete);
    } else {
      _showSnackBar(AppLocalizations.of(context)!.printFailed);
    }
  }

  Future<void> _printRotatedImage() async {
    if (_selectedImage == null) {
      _showSnackBar(AppLocalizations.of(context)!.photoGallery);
      return;
    }

    if (!_printerService.isConnected) {
      _showSnackBar(AppLocalizations.of(context)!.printerNotConnected);
      return;
    }

    _showSnackBar(AppLocalizations.of(context)!.printing);
    final success = await _printerService.printImageRotated(_selectedImage!, rotationAngle: 90.0);
    if (success) {
      _showSnackBar(AppLocalizations.of(context)!.printComplete);
    } else {
      _showSnackBar(AppLocalizations.of(context)!.printFailed);
    }
  }

  void _showSnackBar(String message) {
    final l10n = AppLocalizations.of(context)!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.printButton),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () async {
              await _captureImage();
            },
            tooltip: l10n.scan,
          ),
          IconButton(
            icon: Icon(_isConnected ? Icons.print : Icons.print_disabled),
            onPressed: _isConnected ? null : () async {
              bool connected = await _printerService.connectToPrinter();
              setState(() {
                _isConnected = connected;
              });
              if (connected) {
                _showSnackBar(l10n.printerConnected);
              } else {
                _showSnackBar(l10n.connectionFailed);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      color: _isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isConnected ? l10n.printerConnected : l10n.printerNotConnected,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image selection buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectImage,
                  icon: const Icon(Icons.image),
                  label: Text(l10n.photoGallery),
                ),
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(l10n.takePhoto),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Print buttons
            if (_selectedImage != null)
              Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Image.memory(_selectedImage!, fit: BoxFit.contain),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _printSelectedImage,
                        icon: const Icon(Icons.print),
                        label: Text(l10n.print),
                      ),
                      ElevatedButton.icon(
                        onPressed: _printRotatedImage,
                        icon: const Icon(Icons.rotate_right),
                        label: Text(l10n.rotate90),
                      ),
                    ],
                  ),
                ],
              ),
            
            const SizedBox(height: 16),
            
            // Text printing section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.textToPrint, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => _selectedText = value,
                      decoration: InputDecoration(
                        hintText: l10n.enterText,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _printText,
                          icon: const Icon(Icons.print),
                          label: Text(l10n.longText),
                        ),
                        ElevatedButton.icon(
                          onPressed: _printRotatedText,
                          icon: const Icon(Icons.rotate_90_degrees_ccw),
                          label: Text(l10n.horizontalPrinting),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Printer status section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.printerConnected, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: !_isConnected ? null : () async {
                            final state = await _printerService.getPrinterState();
                            if (state != null) {
                              _showSnackBar(l10n.printing);
                              print('Printer State: $state');
                            }
                          },
                          icon: const Icon(Icons.info),
                          label: Text(l10n.printerConnected),
                        ),
                        OutlinedButton.icon(
                          onPressed: !_isConnected ? null : () async {
                            await _printerService.disconnectFromPrinter();
                            setState(() {
                              _isConnected = false;
                            });
                            _showSnackBar(l10n.disconnectPrinter);
                          },
                          icon: const Icon(Icons.bluetooth_disabled),
                          label: Text(l10n.disconnectPrinter),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}