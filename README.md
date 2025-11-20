# Busina Print

The app for cat printers. 🐱🖨️

## Supported Printers
- GB* (tested on GB03)
- GT* (not tested, like GT01)
- Pretty much everything that uses iPrint app (not to be confused with Epson iPrint)

## Getting Started
Compiled binary (release and ci builds) are only on Android for a moment. Download the latest from the release tab.

Building is pretty much like every other flutter app:
```
flutter pub get
flutter gen-l10n
flutter build ... --release # apk, aab, ipa, windows, macos, linux
```

Run the test server for development and testing:
```
flutter pub get
flutter gen-l10n
flutter run   # Use --release flag to test without debugging
```

## Contributing
Send a pull request! You are absolutely welcome! 😄 Or open an issue/text me on TG (@GooseDev72)

## Credits
[catprinter](https://github.com/rbaron/catprinter.git)
The official iPrint app (search yourself, decompiled using only JaDX)

<3 to the Flutter team!


