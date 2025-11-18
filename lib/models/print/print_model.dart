class PrintModel {
  final String name;
  final String id;
  final String? description;
  final PrintType type;
  
  PrintModel({
    required this.name,
    required this.id,
    this.description,
    required this.type,
  });
}

enum PrintType {
  image,
  text,
  mixed,
  label,
  template,
}

class PrintSettings {
  final double printQuality;
  final int copies;
  final bool rotated;
  final double rotationAngle;
  final int printSpeed;
  final int energyLevel;
  final String? ditherAlgorithm;
  
  PrintSettings({
    this.printQuality = 1.0,
    this.copies = 1,
    this.rotated = false,
    this.rotationAngle = 0.0,
    this.printSpeed = 10,
    this.energyLevel = 0xFFFF,
    this.ditherAlgorithm,
  });
}