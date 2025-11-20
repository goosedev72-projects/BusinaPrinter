import 'package:flutter/material.dart';
import '../core/data/models/print_settings.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';

class PrintSettingsPage extends StatefulWidget {
  final Function(Locale) changeLocaleCallback;

  const PrintSettingsPage({Key? key, required this.changeLocaleCallback}) : super(key: key);

  @override
  _PrintSettingsPageState createState() => _PrintSettingsPageState();
}

class _PrintSettingsPageState extends State<PrintSettingsPage> {
  late PrintSettings _settings;
  final List<String> _ditherAlgorithms = ['floyd-steinberg', 'atkinson', 'ordered', 'simple-threshold'];
  String _selectedAlgorithm = 'floyd-steinberg';

  @override
  void initState() {
    super.initState();
    _settings = const PrintSettings();
    _selectedAlgorithm = _settings.ditherAlgorithm ?? 'floyd-steinberg';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.printSettings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Language Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.language),
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.english),
                    value: 'en',
                    groupValue: Localizations.localeOf(context).languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        widget.changeLocaleCallback(const Locale('en', ''));
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.russian),
                    value: 'ru',
                    groupValue: Localizations.localeOf(context).languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        widget.changeLocaleCallback(const Locale('ru', ''));
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image Processing Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.imageProcessing),
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedAlgorithm,
                    decoration: InputDecoration(
                      labelText: l10n.ditherAlgorithm,
                      border: const OutlineInputBorder(),
                    ),
                    items: _ditherAlgorithms.map((String algorithm) {
                      String localizedAlgorithm = algorithm;
                      if (algorithm == 'floyd-steinberg') localizedAlgorithm = l10n.floydSteinberg;
                      else if (algorithm == 'atkinson') localizedAlgorithm = l10n.atkinson;
                      else if (algorithm == 'halftone') localizedAlgorithm = l10n.halftone;
                      else if (algorithm == 'mean-threshold') localizedAlgorithm = l10n.meanThreshold;
                      
                      return DropdownMenuItem<String>(
                        value: algorithm,
                        child: Text(localizedAlgorithm),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAlgorithm = newValue ?? 'floyd-steinberg';
                        _settings = _settings.copyWith(ditherAlgorithm: newValue);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.invertImage),
                    value: _settings.invert,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(invert: value);
                      });
                    },
                    subtitle: Text(l10n.invertImageDescription ?? l10n.invertImage),
                  ),
                  SliderListTile(
                    title: l10n.threshold,
                    value: _settings.threshold,
                    min: 0.0,
                    max: 255.0,
                    divisions: 255,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(threshold: value);
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Print Quality and Energy Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.quality),
                children: [
                  SliderListTile(
                    title: l10n.scale,
                    value: _settings.scale,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(scale: value);
                      });
                    },
                  ),
                  SliderListTile(
                    title: l10n.energyLevel,
                    value: _settings.energyLevel.toDouble(),
                    min: 0.0,
                    max: 65535.0,
                    divisions: 65535,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(energyLevel: value.toInt());
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Print Quantity Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.quantity),
                children: [
                  SliderListTile(
                    title: l10n.copies,
                    value: _settings.copies.toDouble(),
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(copies: value.round());
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Rotation Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.imageRotation),
                children: [
                  SliderListTile(
                    title: l10n.rotationAngle,
                    value: _settings.rotationAngle,
                    min: 0.0,
                    max: 360.0,
                    divisions: 360,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(rotationAngle: value);
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Paper Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.paperSettings),
                children: [
                  SwitchListTile(
                    title: Text(l10n.labels),
                    value: false,
                    onChanged: (value) {
                      // TODO: Implement label option
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.autoFeed),
                    value: true,
                    onChanged: (value) {
                      // TODO: Implement auto feed option
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Spacer Settings
            Card(
              child: ExpansionTile(
                title: Text(l10n.spacerSettings),
                children: [
                  SliderListTile(
                    title: l10n.spacerHeight,
                    value: _settings.spacerHeight.toDouble(),
                    min: 0.0,
                    max: 200.0,
                    divisions: 200,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(spacerHeight: value.round());
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderListTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final Function(double) onChanged;

  const SliderListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toStringAsFixed(2),
            onChanged: onChanged,
          ),
          Text(
            '${value.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}