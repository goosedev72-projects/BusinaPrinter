import 'package:flutter/material.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';
import 'ble_tester_page.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  // Debug variables
  String _debugLog = '';
  bool _isDebugEnabled = false;
  bool _keepScreenOn = false;

  void _addToLog(String message) {
    setState(() {
      _debugLog = '${DateTime.now()}: $message\n$_debugLog';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debug),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BLE Testing Tool
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BLE Testing Tool', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BleTesterPage()),
                        );
                      },
                      icon: const Icon(Icons.bluetooth),
                      label: const Text('Open BLE Tester'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Debug Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.debugSettings, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(l10n.enableDebugging),
                      value: _isDebugEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isDebugEnabled = value;
                        });
                        _addToLog('Debugging ${value ? "enabled" : "disabled"}');
                      },
                    ),
                    SwitchListTile(
                      title: Text(l10n.keepScreenOn),
                      value: _keepScreenOn,
                      onChanged: (value) {
                        setState(() {
                          _keepScreenOn = value;
                        });
                        _addToLog('Screen keep-on ${value ? "enabled" : "disabled"}');
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _debugLog = '';
                        });
                        _addToLog('Debug log cleared');
                      },
                      icon: const Icon(Icons.clear),
                      label: Text(l10n.clearLog),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Debug Log
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.debugLog, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SingleChildScrollView(
                            reverse: true, // Show latest at bottom
                            child: Text(
                              _debugLog,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}