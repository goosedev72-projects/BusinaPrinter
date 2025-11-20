// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Busina Print';

  @override
  String get printButton => 'Print';

  @override
  String get settingsButton => 'Settings';

  @override
  String get imagePacks => 'Image Packs';

  @override
  String get photoEditor => 'Photo Editor';

  @override
  String get longText => 'Long Text';

  @override
  String get printSettings => 'Print Settings';

  @override
  String get quality => 'Quality';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get ditherAlgorithm => 'Dither Algorithm';

  @override
  String get threshold => 'Threshold';

  @override
  String get floydSteinberg => 'Floyd-Steinberg';

  @override
  String get atkinson => 'Atkinson';

  @override
  String get halftone => 'Halftone';

  @override
  String get meanThreshold => 'Mean Threshold';

  @override
  String get copies => 'Copies';

  @override
  String get print => 'Print';

  @override
  String get preview => 'Preview';

  @override
  String get photoGallery => 'Photo Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get editPhoto => 'Edit Photo';

  @override
  String get addNewPack => 'Add New Pack';

  @override
  String get packName => 'Pack Name';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteMessage => 'Are you sure you want to delete this item?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get textToPrint => 'Text to Print';

  @override
  String get enterText => 'Enter your text here...';

  @override
  String get horizontalPrinting => 'Horizontal Printing';

  @override
  String get verticalPrinting => 'Vertical Printing';

  @override
  String get imageRotation => 'Image Rotation';

  @override
  String get rotate90 => 'Rotate 90°';

  @override
  String get rotate180 => 'Rotate 180°';

  @override
  String get rotate270 => 'Rotate 270°';

  @override
  String get energyLevel => 'Energy Level';

  @override
  String get light => 'Light';

  @override
  String get normal => 'Normal';

  @override
  String get dark => 'Dark';

  @override
  String get printerConnected => 'Printer Connected';

  @override
  String get printerNotConnected => 'Printer Not Connected';

  @override
  String get connectPrinter => 'Connect Printer';

  @override
  String get disconnectPrinter => 'Disconnect Printer';

  @override
  String get connectionFailed => 'Connection Failed';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get localeSwitch => 'Switch Language';

  @override
  String get scan => 'Scan';

  @override
  String get usageGuideStep1 => '1. Prerequisites & Initial Setup';

  @override
  String get usageGuideStep1Desc =>
      '• Ensure your thermal printer is fully charged\n• Enable Bluetooth on your mobile device\n• Make sure the printer is turned on and in pairing mode\n• Install the Busina Print App from the app store\n• Grant necessary permissions when prompted';

  @override
  String get usageGuideStep2 => '2. Connecting to Your Printer';

  @override
  String get usageGuideStep2Desc =>
      '• Open the Busina Print App\n• Look for the Bluetooth connection icon in the top-right corner\n• Tap the icon to start scanning for available printers\n• Select your printer from the list (common names: GT01, GT02, GB03, etc.)\n• Wait for the connection confirmation message\n• A green Bluetooth icon indicates a successful connection';

  @override
  String get usageGuideStep3 => '3. Printing Images from Your Device';

  @override
  String get usageGuideStep3Desc =>
      '• Navigate to the main \"Print\" tab\n• Tap the \"Select Image\" button (camera icon) to choose from your photo gallery\n• Select the image you want to print\n• Preview the image in the app\n• Choose between normal print or rotated print (for longer prints)\n• Tap the \"Print\" button and wait for the printing process to complete\n• Note: Image quality can be adjusted in Settings before printing';

  @override
  String get usageGuideStep4 => '4. Printing Text';

  @override
  String get usageGuideStep4Desc =>
      '• Go to the main \"Print\" tab\n• Find the text input section\n• Enter your text in the provided text field\n• Use the \"Print Text\" button for standard printing\n• Use \"Horizontal Printing\" for long, continuous text that extends the paper\n• Text formatting will be preserved based on your settings';

  @override
  String get usageGuideStep5 => '5. Using Image Packs (Organizing Your Prints)';

  @override
  String get usageGuideStep5Desc =>
      '• Navigate to the \"Packs\" tab\n• Create new image packs or browse existing ones\n• Add images to packs for organized printing\n• Access and print images directly from your saved packs\n• Great for frequently printed images or themed collections';

  @override
  String get usageGuideStep6 => '6. Customizing Print Settings';

  @override
  String get usageGuideStep6Desc =>
      '• Access settings via the gear icon in the top-right\n• Adjust print quality using the energy level setting:\n  - Higher energy: darker, more intense prints (uses more battery)\n  - Lower energy: lighter prints (conserves battery)\n• Select dithering algorithms for image processing:\n  - Floyd-Steinberg: good for general images\n  - Atkinson: good for line art and simple graphics\n  - Burkes: good middle ground\n  - Stucki: good for detailed images\n• Set number of copies for automatic repeated printing\n• Adjust threshold and inversion settings for optimal image results';

  @override
  String get usageGuideStep7 => '7. Advanced Features';

  @override
  String get usageGuideStep7Desc =>
      '• Camera Integration: Take photos directly in the app for immediate printing\n• Image Rotation: Use the rotate feature for different print orientations\n• Printer Status: Check connection status and printer information\n• Disconnect: Safely disconnect from the printer when finished';

  @override
  String get usageGuideStep8 => '8. Troubleshooting Common Issues';

  @override
  String get usageGuideStep8Desc =>
      '• Connection Problems:\n  - Ensure printer is powered on and in range\n  - Try turning Bluetooth off and on\n  - Restart the app\n  - Power cycle the printer (turn off and on)\n• Poor Print Quality:\n  - Adjust energy level in settings\n  - Try different dithering algorithms\n  - Check if printer has sufficient battery\n• Image Not Printing:\n  - Verify printer connection status\n  - Check image format (JPG, PNG supported)\n  - Ensure image isn\'t too large';

  @override
  String get usageGuideTips => 'Advanced Printer Tips & Best Practices';

  @override
  String get usageGuideTipsDesc =>
      '• For best image results, use high-contrast images with clear subjects\n• Darker energy levels (8-10) produce intense prints but drain battery faster\n• Lighter energy levels (2-4) conserve battery but may produce faint prints\n• Long prints can take 2-5 minutes depending on complexity and size\n• For text printing, avoid very long lines; shorter, well-formatted text prints better\n• Store thermal paper in a cool, dry place to maintain print quality\n• Clean the printer head regularly for optimal performance\n• If prints are faint or streaked, consider replacing thermal paper roll\n• For continuous text printing, use the horizontal printing feature\n• Test print settings on a sample image before printing important documents';

  @override
  String get searching => 'Searching...';

  @override
  String get selectPrinter => 'Select Printer';

  @override
  String get noPrintersFound => 'No printers found';

  @override
  String get printing => 'Printing...';

  @override
  String get printComplete => 'Print Complete!';

  @override
  String get printFailed => 'Print Failed';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get debug => 'Debug';

  @override
  String get debugSettings => 'Debug Settings';

  @override
  String get enableDebugging => 'Enable Debugging';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get clearLog => 'Clear Log';

  @override
  String get debugLog => 'Debug Log';

  @override
  String get invertImage => 'Invert Image';

  @override
  String get invertImageDescription =>
      'Invert black and white pixels in the image';

  @override
  String get imageProcessing => 'Image Processing';

  @override
  String get quantity => 'Quantity';

  @override
  String get rotationAngle => 'Rotation Angle';

  @override
  String get paperSettings => 'Paper Settings';

  @override
  String get labels => 'Labels';

  @override
  String get autoFeed => 'Auto Feed';

  @override
  String get scale => 'Scale';

  @override
  String get spacerSettings => 'Spacer Settings';

  @override
  String get spacerHeight => 'Spacer Height';

  @override
  String get usageGuide => 'Usage Guide';
}
