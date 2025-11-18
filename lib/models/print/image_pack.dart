import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class ImagePack {
  final String id;
  final String name;
  final String description;
  final List<PackImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final bool isPublic;

  ImagePack({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.category = 'General',
    this.isPublic = false,
  });

  ImagePack copyWith({
    String? id,
    String? name,
    String? description,
    List<PackImage>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    bool? isPublic,
  }) {
    return ImagePack(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images.map((image) => image.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category,
      'isPublic': isPublic,
    };
  }

  factory ImagePack.fromJson(Map<String, dynamic> json) {
    return ImagePack(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images: (json['images'] as List).map((image) => PackImage.fromJson(image)).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: json['category'] as String,
      isPublic: json['isPublic'] as bool,
    );
  }
}

class PackImage {
  final String id;
  final String name;
  final Uint8List imageData;
  final DateTime addedAt;
  final Map<String, dynamic> processingParams;

  PackImage({
    required this.id,
    required this.name,
    required this.imageData,
    required this.addedAt,
    this.processingParams = const {},
  });

  PackImage copyWith({
    String? id,
    String? name,
    Uint8List? imageData,
    DateTime? addedAt,
    Map<String, dynamic>? processingParams,
  }) {
    return PackImage(
      id: id ?? this.id,
      name: name ?? this.name,
      imageData: imageData ?? this.imageData,
      addedAt: addedAt ?? this.addedAt,
      processingParams: processingParams ?? this.processingParams,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageData': imageData, // This will be handled specially in serialization
      'addedAt': addedAt.toIso8601String(),
      'processingParams': processingParams,
    };
  }

  factory PackImage.fromJson(Map<String, dynamic> json) {
    return PackImage(
      id: json['id'] as String,
      name: json['name'] as String,
      imageData: json['imageData'] as Uint8List, // This might need special handling
      addedAt: DateTime.parse(json['addedAt'] as String),
      processingParams: json['processingParams'] as Map<String, dynamic>,
    );
  }
}