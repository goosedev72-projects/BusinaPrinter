import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Busina Print'**
  String get appTitle;

  /// No description provided for @printButton.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printButton;

  /// No description provided for @settingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// No description provided for @imagePacks.
  ///
  /// In en, this message translates to:
  /// **'Image Packs'**
  String get imagePacks;

  /// No description provided for @photoEditor.
  ///
  /// In en, this message translates to:
  /// **'Photo Editor'**
  String get photoEditor;

  /// No description provided for @longText.
  ///
  /// In en, this message translates to:
  /// **'Long Text'**
  String get longText;

  /// No description provided for @printSettings.
  ///
  /// In en, this message translates to:
  /// **'Print Settings'**
  String get printSettings;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @ditherAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Dither Algorithm'**
  String get ditherAlgorithm;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// No description provided for @floydSteinberg.
  ///
  /// In en, this message translates to:
  /// **'Floyd-Steinberg'**
  String get floydSteinberg;

  /// No description provided for @atkinson.
  ///
  /// In en, this message translates to:
  /// **'Atkinson'**
  String get atkinson;

  /// No description provided for @halftone.
  ///
  /// In en, this message translates to:
  /// **'Halftone'**
  String get halftone;

  /// No description provided for @meanThreshold.
  ///
  /// In en, this message translates to:
  /// **'Mean Threshold'**
  String get meanThreshold;

  /// No description provided for @copies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get copies;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @editPhoto.
  ///
  /// In en, this message translates to:
  /// **'Edit Photo'**
  String get editPhoto;

  /// No description provided for @addNewPack.
  ///
  /// In en, this message translates to:
  /// **'Add New Pack'**
  String get addNewPack;

  /// No description provided for @packName.
  ///
  /// In en, this message translates to:
  /// **'Pack Name'**
  String get packName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @textToPrint.
  ///
  /// In en, this message translates to:
  /// **'Text to Print'**
  String get textToPrint;

  /// No description provided for @enterText.
  ///
  /// In en, this message translates to:
  /// **'Enter your text here...'**
  String get enterText;

  /// No description provided for @horizontalPrinting.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Printing'**
  String get horizontalPrinting;

  /// No description provided for @verticalPrinting.
  ///
  /// In en, this message translates to:
  /// **'Vertical Printing'**
  String get verticalPrinting;

  /// No description provided for @imageRotation.
  ///
  /// In en, this message translates to:
  /// **'Image Rotation'**
  String get imageRotation;

  /// No description provided for @rotate90.
  ///
  /// In en, this message translates to:
  /// **'Rotate 90°'**
  String get rotate90;

  /// No description provided for @rotate180.
  ///
  /// In en, this message translates to:
  /// **'Rotate 180°'**
  String get rotate180;

  /// No description provided for @rotate270.
  ///
  /// In en, this message translates to:
  /// **'Rotate 270°'**
  String get rotate270;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get energyLevel;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @printerConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer Connected'**
  String get printerConnected;

  /// No description provided for @printerNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer Not Connected'**
  String get printerNotConnected;

  /// No description provided for @connectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Connect Printer'**
  String get connectPrinter;

  /// No description provided for @disconnectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Printer'**
  String get disconnectPrinter;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @localeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get localeSwitch;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @usageGuideStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Prerequisites & Initial Setup'**
  String get usageGuideStep1;

  /// No description provided for @usageGuideStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'• Ensure your thermal printer is fully charged\n• Enable Bluetooth on your mobile device\n• Make sure the printer is turned on and in pairing mode\n• Install the Busina Print App from the app store\n• Grant necessary permissions when prompted'**
  String get usageGuideStep1Desc;

  /// No description provided for @usageGuideStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Connecting to Your Printer'**
  String get usageGuideStep2;

  /// No description provided for @usageGuideStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'• Open the Busina Print App\n• Look for the Bluetooth connection icon in the top-right corner\n• Tap the icon to start scanning for available printers\n• Select your printer from the list (common names: GT01, GT02, GB03, etc.)\n• Wait for the connection confirmation message\n• A green Bluetooth icon indicates a successful connection'**
  String get usageGuideStep2Desc;

  /// No description provided for @usageGuideStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Printing Images from Your Device'**
  String get usageGuideStep3;

  /// No description provided for @usageGuideStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'• Navigate to the main \"Print\" tab\n• Tap the \"Select Image\" button (camera icon) to choose from your photo gallery\n• Select the image you want to print\n• Preview the image in the app\n• Choose between normal print or rotated print (for longer prints)\n• Tap the \"Print\" button and wait for the printing process to complete\n• Note: Image quality can be adjusted in Settings before printing'**
  String get usageGuideStep3Desc;

  /// No description provided for @usageGuideStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Printing Text'**
  String get usageGuideStep4;

  /// No description provided for @usageGuideStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'• Go to the main \"Print\" tab\n• Find the text input section\n• Enter your text in the provided text field\n• Use the \"Print Text\" button for standard printing\n• Use \"Horizontal Printing\" for long, continuous text that extends the paper\n• Text formatting will be preserved based on your settings'**
  String get usageGuideStep4Desc;

  /// No description provided for @usageGuideStep5.
  ///
  /// In en, this message translates to:
  /// **'5. Using Image Packs (Organizing Your Prints)'**
  String get usageGuideStep5;

  /// No description provided for @usageGuideStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'• Navigate to the \"Packs\" tab\n• Create new image packs or browse existing ones\n• Add images to packs for organized printing\n• Access and print images directly from your saved packs\n• Great for frequently printed images or themed collections'**
  String get usageGuideStep5Desc;

  /// No description provided for @usageGuideStep6.
  ///
  /// In en, this message translates to:
  /// **'6. Customizing Print Settings'**
  String get usageGuideStep6;

  /// No description provided for @usageGuideStep6Desc.
  ///
  /// In en, this message translates to:
  /// **'• Access settings via the gear icon in the top-right\n• Adjust print quality using the energy level setting:\n  - Higher energy: darker, more intense prints (uses more battery)\n  - Lower energy: lighter prints (conserves battery)\n• Select dithering algorithms for image processing:\n  - Floyd-Steinberg: good for general images\n  - Atkinson: good for line art and simple graphics\n  - Burkes: good middle ground\n  - Stucki: good for detailed images\n• Set number of copies for automatic repeated printing\n• Adjust threshold and inversion settings for optimal image results'**
  String get usageGuideStep6Desc;

  /// No description provided for @usageGuideStep7.
  ///
  /// In en, this message translates to:
  /// **'7. Advanced Features'**
  String get usageGuideStep7;

  /// No description provided for @usageGuideStep7Desc.
  ///
  /// In en, this message translates to:
  /// **'• Camera Integration: Take photos directly in the app for immediate printing\n• Image Rotation: Use the rotate feature for different print orientations\n• Printer Status: Check connection status and printer information\n• Disconnect: Safely disconnect from the printer when finished'**
  String get usageGuideStep7Desc;

  /// No description provided for @usageGuideStep8.
  ///
  /// In en, this message translates to:
  /// **'8. Troubleshooting Common Issues'**
  String get usageGuideStep8;

  /// No description provided for @usageGuideStep8Desc.
  ///
  /// In en, this message translates to:
  /// **'• Connection Problems:\n  - Ensure printer is powered on and in range\n  - Try turning Bluetooth off and on\n  - Restart the app\n  - Power cycle the printer (turn off and on)\n• Poor Print Quality:\n  - Adjust energy level in settings\n  - Try different dithering algorithms\n  - Check if printer has sufficient battery\n• Image Not Printing:\n  - Verify printer connection status\n  - Check image format (JPG, PNG supported)\n  - Ensure image isn\'t too large'**
  String get usageGuideStep8Desc;

  /// No description provided for @usageGuideTips.
  ///
  /// In en, this message translates to:
  /// **'Advanced Printer Tips & Best Practices'**
  String get usageGuideTips;

  /// No description provided for @usageGuideTipsDesc.
  ///
  /// In en, this message translates to:
  /// **'• For best image results, use high-contrast images with clear subjects\n• Darker energy levels (8-10) produce intense prints but drain battery faster\n• Lighter energy levels (2-4) conserve battery but may produce faint prints\n• Long prints can take 2-5 minutes depending on complexity and size\n• For text printing, avoid very long lines; shorter, well-formatted text prints better\n• Store thermal paper in a cool, dry place to maintain print quality\n• Clean the printer head regularly for optimal performance\n• If prints are faint or streaked, consider replacing thermal paper roll\n• For continuous text printing, use the horizontal printing feature\n• Test print settings on a sample image before printing important documents'**
  String get usageGuideTipsDesc;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @selectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Select Printer'**
  String get selectPrinter;

  /// No description provided for @noPrintersFound.
  ///
  /// In en, this message translates to:
  /// **'No printers found'**
  String get noPrintersFound;

  /// No description provided for @printing.
  ///
  /// In en, this message translates to:
  /// **'Printing...'**
  String get printing;

  /// No description provided for @printComplete.
  ///
  /// In en, this message translates to:
  /// **'Print Complete!'**
  String get printComplete;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Print Failed'**
  String get printFailed;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @debugSettings.
  ///
  /// In en, this message translates to:
  /// **'Debug Settings'**
  String get debugSettings;

  /// No description provided for @enableDebugging.
  ///
  /// In en, this message translates to:
  /// **'Enable Debugging'**
  String get enableDebugging;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// No description provided for @clearLog.
  ///
  /// In en, this message translates to:
  /// **'Clear Log'**
  String get clearLog;

  /// No description provided for @debugLog.
  ///
  /// In en, this message translates to:
  /// **'Debug Log'**
  String get debugLog;

  /// No description provided for @invertImage.
  ///
  /// In en, this message translates to:
  /// **'Invert Image'**
  String get invertImage;

  /// No description provided for @invertImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Invert black and white pixels in the image'**
  String get invertImageDescription;

  /// No description provided for @imageProcessing.
  ///
  /// In en, this message translates to:
  /// **'Image Processing'**
  String get imageProcessing;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @rotationAngle.
  ///
  /// In en, this message translates to:
  /// **'Rotation Angle'**
  String get rotationAngle;

  /// No description provided for @paperSettings.
  ///
  /// In en, this message translates to:
  /// **'Paper Settings'**
  String get paperSettings;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @autoFeed.
  ///
  /// In en, this message translates to:
  /// **'Auto Feed'**
  String get autoFeed;

  /// No description provided for @scale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get scale;

  /// No description provided for @spacerSettings.
  ///
  /// In en, this message translates to:
  /// **'Spacer Settings'**
  String get spacerSettings;

  /// No description provided for @spacerHeight.
  ///
  /// In en, this message translates to:
  /// **'Spacer Height'**
  String get spacerHeight;

  /// No description provided for @usageGuide.
  ///
  /// In en, this message translates to:
  /// **'Usage Guide'**
  String get usageGuide;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
