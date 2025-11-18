import 'dart:typed_data';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'image_pack_repository.dart';
import '../data/models/image_pack.dart';

/// Default implementation of ImagePackRepository using shared preferences
class DefaultImagePackRepository implements ImagePackRepository {
  static const String _packsKey = 'image_packs';
  
  @override
  Future<List<ImagePack>> loadPacks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_packsKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => _fromJson(json)).toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }
  
  @override
  Future<void> savePacks(List<ImagePack> packs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = packs.map((pack) => _toJson(pack)).toList();
    await prefs.setString(_packsKey, json.encode(jsonList));
  }
  
  @override
  Future<void> addPack(ImagePack pack) async {
    final packs = await loadPacks();
    packs.add(pack);
    await savePacks(packs);
  }
  
  @override
  Future<void> updatePack(ImagePack pack) async {
    final packs = await loadPacks();
    final index = packs.indexWhere((p) => p.id == pack.id);
    if (index != -1) {
      packs[index] = pack;
      await savePacks(packs);
    }
  }
  
  @override
  Future<void> removePack(String packId) async {
    final packs = await loadPacks();
    packs.removeWhere((pack) => pack.id == packId);
    await savePacks(packs);
  }
  
  @override
  Future<void> addImageToPack(String packId, PackImage image) async {
    final packs = await loadPacks();
    final packIndex = packs.indexWhere((p) => p.id == packId);
    
    if (packIndex != -1) {
      packs[packIndex].images.add(image);
      await savePacks(packs);
    }
  }
  
  @override
  Future<void> removeImageFromPack(String packId, String imageId) async {
    final packs = await loadPacks();
    final packIndex = packs.indexWhere((p) => p.id == packId);
    
    if (packIndex != -1) {
      packs[packIndex].images.removeWhere((image) => image.id == imageId);
      await savePacks(packs);
    }
  }
  
  @override
  Future<ImagePack?> getPack(String packId) async {
    final packs = await loadPacks();
    try {
      return packs.firstWhere((pack) => pack.id == packId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ImagePack>> getPacksByCategory(String category) async {
    final allPacks = await loadPacks();
    return allPacks.where((pack) => pack.category.toLowerCase().contains(category.toLowerCase())).toList();
  }
  
  @override
  Future<List<String>> getAllCategories() async {
    final allPacks = await loadPacks();
    final categories = <String>{};
    
    for (final pack in allPacks) {
      categories.add(pack.category);
    }
    
    return categories.toList();
  }
  
  /// Convert ImagePack to JSON (with special handling for image data)
  Map<String, dynamic> _toJson(ImagePack pack) {
    final jsonMap = pack.toJson();
    // Convert images to a more storage-friendly format
    final imagesJson = <Map<String, dynamic>>[];
    for (final image in pack.images) {
      imagesJson.add({
        'id': image.id,
        'name': image.name,
        'imageData': base64Encode(image.imageData), // Encode image data as base64
        'addedAt': image.addedAt.toIso8601String(),
        'processingParams': image.processingParams,
      });
    }
    jsonMap['images'] = imagesJson;
    return jsonMap;
  }
  
  /// Convert JSON to ImagePack (with special handling for image data)
  ImagePack _fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'] as List;
    final images = <PackImage>[];
    
    for (final imageJson in imagesJson) {
      images.add(PackImage(
        id: imageJson['id'],
        name: imageJson['name'],
        imageData: base64Decode(imageJson['imageData']), // Decode base64 image data
        addedAt: DateTime.parse(imageJson['addedAt']),
        processingParams: imageJson['processingParams'] as Map<String, dynamic>,
      ));
    }
    
    return ImagePack(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      images: images,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: json['category'],
      isPublic: json['isPublic'],
    );
  }
}