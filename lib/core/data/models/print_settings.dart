class PrintSettings {
  final String? ditherAlgorithm;
  final double threshold;
  final bool invert;
  final int energyLevel;
  final int copies;
  final double rotationAngle;
  final double scale;
  final int spacerHeight;
  
  const PrintSettings({
    this.ditherAlgorithm = 'floyd-steinberg',
    this.threshold = 128.0,
    this.invert = false,  // Default to false to match iPrint behavior
    this.energyLevel = 0xffff,
    this.copies = 1,
    this.rotationAngle = 0.0,
    this.scale = 1.0,
    this.spacerHeight = 50, // Default spacer height in pixels
  });
  
  PrintSettings copyWith({
    String? ditherAlgorithm,
    double? threshold,
    bool? invert,
    int? energyLevel,
    int? copies,
    double? rotationAngle,
    double? scale,
    int? spacerHeight,
  }) {
    return PrintSettings(
      ditherAlgorithm: ditherAlgorithm ?? this.ditherAlgorithm,
      threshold: threshold ?? this.threshold,
      invert: invert ?? this.invert,
      energyLevel: energyLevel ?? this.energyLevel,
      copies: copies ?? this.copies,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      scale: scale ?? this.scale,
      spacerHeight: spacerHeight ?? this.spacerHeight,
    );
  }
}