import 'package:flutter/material.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/printing_page.dart';
import 'pages/settings_page.dart';
import 'pages/usage_guide_page.dart';
import 'pages/image_packs_page.dart';
import 'pages/ble_tester_page.dart';
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

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LocaleManager.getSelectedLocale();
    setState(() {
      _selectedLocale = locale;
    });
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _selectedLocale = newLocale;
    });
    LocaleManager.setSelectedLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        changeLocaleCallback: _changeLocale,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(Locale) changeLocaleCallback;

  const HomePage({Key? key, required this.changeLocaleCallback}) : super(key: key);

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