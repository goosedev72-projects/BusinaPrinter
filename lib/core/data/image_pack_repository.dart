import '../data/models/image_pack.dart';

/// Interface for image pack operations
abstract class ImagePackRepository {
  /// Load all image packs from storage
  Future<List<ImagePack>> loadPacks();

  /// Save all image packs to storage
  Future<void> savePacks(List<ImagePack> packs);

  /// Add a new image pack
  Future<void> addPack(ImagePack pack);

  /// Update an existing image pack
  Future<void> updatePack(ImagePack pack);

  /// Remove an image pack
  Future<void> removePack(String packId);

  /// Add an image to a pack
  Future<void> addImageToPack(String packId, PackImage image);

  /// Remove an image from a pack
  Future<void> removeImageFromPack(String packId, String imageId);

  /// Get a specific pack by ID
  Future<ImagePack?> getPack(String packId);

  /// Get all packs by category
  Future<List<ImagePack>> getPacksByCategory(String category);

  /// Get all unique categories
  Future<List<String>> getAllCategories();
}