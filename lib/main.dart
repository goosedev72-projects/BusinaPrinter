import 'package:flutter/material.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/printing_page.dart';
import 'pages/settings_page.dart';
import 'pages/usage_guide_page.dart';
import 'pages/image_packs_page.dart';
import 'pages/debug_page.dart';
import 'core/utils/locale_manager.dart';

void main() {
  runApp(const BusinaPrintApp());
}

class BusinaPrintApp extends StatefulWidget {
  const BusinaPrintApp({Key? key}) : super(key: key);

  @override
  State<BusinaPrintApp> createState() => _BusinaPrintAppState();
}

class _BusinaPrintAppState extends State<BusinaPrintApp> {
  Locale? _selectedLocale;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final locale = await LocaleManager.getSelectedLocale();
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;

    setState(() {
      _selectedLocale = locale;
      _isDarkMode = isDarkMode;
    });
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _selectedLocale = newLocale;
    });
    LocaleManager.setSelectedLocale(newLocale);
  }

  void _toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newDarkMode = !_isDarkMode;
    await prefs.setBool('isDarkMode', newDarkMode);

    setState(() {
      _isDarkMode = newDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple);
        ColorScheme darkColorScheme = darkDynamic ?? ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        );

        return MaterialApp(
          title: 'Busina Print App',
          locale: _selectedLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: _isDarkMode ? darkColorScheme : lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(
            changeLocaleCallback: _changeLocale,
            toggleDarkModeCallback: _toggleDarkMode,
            isDarkMode: _isDarkMode,
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(Locale) changeLocaleCallback;
  final VoidCallback toggleDarkModeCallback;
  final bool isDarkMode;

  const HomePage({
    Key? key,
    required this.changeLocaleCallback,
    required this.toggleDarkModeCallback,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Main pages for the bottom navigation - removed ImagePacksPage to hide stickers tab
    final List<Widget> _mainPages = [
      PrintingPage(changeLocaleCallback: widget.changeLocaleCallback),  // Index 0 - Print page
      PrintSettingsPage(changeLocaleCallback: widget.changeLocaleCallback),  // Index 1 - Settings page (was Index 2)
    ];

    // Additional pages accessible through app bar
    final List<Widget> _additionalPages = [
      UsageGuidePage(changeLocaleCallback: widget.changeLocaleCallback),
      DebugPage(),
      ImagePacksPage(changeLocaleCallback: widget.changeLocaleCallback), // Still available but not in main navigation
    ];

    // Combined list for navigation
    final List<Widget> _allPages = [..._mainPages, ..._additionalPages];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleDarkModeCallback,
            tooltip: widget.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report), // Changed to debug icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebugPage()),
              );
            },
            tooltip: l10n.debug,
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsageGuidePage(changeLocaleCallback: widget.changeLocaleCallback)),
              );
            },
            tooltip: l10n.usageGuide ?? "Usage Guide", // Fallback if not defined
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _mainPages, // Only main pages in IndexedStack
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.print),
            label: l10n.printButton,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.settingsButton,
          ),
        ],
      ),
    );
  }
}