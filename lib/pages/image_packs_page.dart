import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../core/data/models/image_pack.dart';
import '../core/data/image_pack_repository.dart';
import '../core/service_locator.dart';
import '../pages/photo_editing_page.dart';
import '../core/image_processing/image_processor.dart';
import '../core/printing/printer_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImagePacksPage extends StatefulWidget {
  const ImagePacksPage({Key? key}) : super(key: key);

  @override
  _ImagePacksPageState createState() => _ImagePacksPageState();
}

class _ImagePacksPageState extends State<ImagePacksPage> {
  final ImagePackRepository _imagePackRepository = ServiceLocator().getImagePackRepository();
  final ImageProcessor _imageProcessor = DefaultImageProcessor();
  final PrinterService _printerService = ServiceLocator().getPrinterService();
  
  List<ImagePack> _packs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPacks();
  }

  Future<void> _loadPacks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final packs = await _imagePackRepository.loadPacks();
      setState(() {
        _packs = packs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.imagePacks} $e')),
      );
    }
  }

  Future<void> _createNewPack() async {
    final l10n = AppLocalizations.of(context)!;
    
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController(text: l10n.imagePacks);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNewPack),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.packName),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: l10n.textToPrint), // Using textToPrint as placeholder
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: l10n.imagePacks), // Using imagePacks as placeholder
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result == true) {
      final newPack = ImagePack(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        description: descriptionController.text,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: categoryController.text,
      );
      
      try {
        await _imagePackRepository.addPack(newPack);
        await _loadPacks(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.imagePacks} $e')),
        );
      }
    }
  }

  Future<void> _addImageToPack(ImagePack pack) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      
      // Preprocess the image
      final processedImageBytes = await _imageProcessor.preprocessImage(
        imageBytes,
        384, // Standard printer width
      );
      
      final newImage = PackImage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Image_${DateTime.now().millisecondsSinceEpoch}',
        imageData: processedImageBytes,
        addedAt: DateTime.now(),
        processingParams: {}, // Will be populated by the preprocessing
      );
      
      try {
        await _imagePackRepository.addImageToPack(pack.id, newImage);
        await _loadPacks(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.photoGallery} $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.imagePacks),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewPack,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _packs.isEmpty
              ? Center(
                  child: Text(
                    '${l10n.imagePacks}\n${l10n.addNewPack}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPacks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _packs.length,
                    itemBuilder: (context, index) {
                      final pack = _packs[index];
                      return _buildPackCard(pack);
                    },
                  ),
                ),
    );
  }

  Widget _buildPackCard(ImagePack pack) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          pack.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${pack.images.length} ${l10n.print} • ${pack.category}'),
        trailing: const Icon(Icons.arrow_drop_down),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pack.description.isNotEmpty)
                  Text(
                    pack.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _addImageToPack(pack),
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(l10n.photoGallery),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _openPackDetails(pack),
                      icon: const Icon(Icons.visibility),
                      label: Text(l10n.preview),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _deletePack(pack),
                      icon: const Icon(Icons.delete),
                      label: Text(l10n.deleteMessage),
                    ),
                  ],
                ),
                if (pack.images.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.preview,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pack.images.length > 3 ? 3 : pack.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[200],
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPackDetails(ImagePack pack) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PackDetailPage(
          pack: pack,
          onPackUpdated: _loadPacks,
        ),
      ),
    );
  }

  Future<void> _deletePack(ImagePack pack) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text('${l10n.deleteMessage} "${pack.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _imagePackRepository.removePack(pack.id);
        await _loadPacks();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.deleteMessage} $e')),
        );
      }
    }
  }
}

class PackDetailPage extends StatefulWidget {
  final ImagePack pack;
  final VoidCallback? onPackUpdated;

  const PackDetailPage({
    Key? key,
    required this.pack,
    this.onPackUpdated,
  }) : super(key: key);

  @override
  _PackDetailPageState createState() => _PackDetailPageState();
}

class _PackDetailPageState extends State<PackDetailPage> {
  late ImagePack _pack;

  late ImagePackRepository _imagePackRepository;
  late ImageProcessor _imageProcessor;
  late PrinterService _printerService;

  @override
  void initState() {
    super.initState();
    _pack = widget.pack;
    _imagePackRepository = ServiceLocator().getImagePackRepository();
    _imageProcessor = DefaultImageProcessor();
    _printerService = ServiceLocator().getPrinterService();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_pack.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pack.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.print} (${_pack.images.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_pack.images.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    '${l10n.photoGallery}\n${l10n.photoEditor}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _pack.images.length,
                  itemBuilder: (context, index) {
                    final image = _pack.images[index];
                    return _buildImageCard(image, index);
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final l10n = AppLocalizations.of(context)!;
          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            final imageBytes = await pickedFile.readAsBytes();
            
            // Navigate to photo editing page
            final editedImageBytes = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhotoEditingPage(initialImage: imageBytes),
              ),
            ) as Uint8List?;
            
            if (editedImageBytes != null) {
              // Preprocess the edited image
              final processedImageBytes = await _imageProcessor.preprocessImage(
                editedImageBytes,
                384,
              );
              
              final newImage = PackImage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: 'Edited_${DateTime.now().millisecondsSinceEpoch}',
                imageData: processedImageBytes,
                addedAt: DateTime.now(),
                processingParams: {},
              );
              
              try {
                await _imagePackRepository.addImageToPack(_pack.id, newImage);
                final updatedPack = await _imagePackRepository.getPack(_pack.id);
                if (updatedPack != null) {
                  setState(() {
                    _pack = updatedPack;
                  });
                  if (widget.onPackUpdated != null) {
                    widget.onPackUpdated!();
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.photoGallery} $e')),
                );
              }
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildImageCard(PackImage image, int index) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              image.name,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () => _deleteImage(index),
                tooltip: l10n.deleteMessage,
              ),
              IconButton(
                icon: const Icon(Icons.print, size: 18),
                onPressed: () => _printImage(image),
                tooltip: l10n.print,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteImage(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final imageId = _pack.images[index].id;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _imagePackRepository.removeImageFromPack(_pack.id, imageId);
        final updatedPack = await _imagePackRepository.getPack(_pack.id);
        if (updatedPack != null) {
          setState(() {
            _pack = updatedPack;
          });
          if (widget.onPackUpdated != null) {
            widget.onPackUpdated!();
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.deleteMessage} $e')),
        );
      }
    }
  }

  void _printImage(PackImage image) async {
    if (!_printerService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.connectPrinter)),
      );
      return;
    }
    
    try {
      final success = await _printerService.printPreprocessedImage(image.imageData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.printComplete)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.printFailed)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.print} $e')),
      );
    }
  }
}