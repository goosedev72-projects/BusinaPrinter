import 'package:flutter/material.dart';
import 'package:busina_print_app/l10n/app_localizations.dart';
import 'ble_tester_page.dart';

class UsageGuidePage extends StatefulWidget {
  final Function(Locale) changeLocaleCallback;

  const UsageGuidePage({Key? key, required this.changeLocaleCallback}) : super(key: key);

  @override
  State<UsageGuidePage> createState() => _UsageGuidePageState();
}

class _UsageGuidePageState extends State<UsageGuidePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.usageGuide ?? "Usage Guide"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appTitle + ' - ' + l10n.usageGuideTips,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep1,
                      l10n.usageGuideStep1Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep2,
                      l10n.usageGuideStep2Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep3,
                      l10n.usageGuideStep3Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep4,
                      l10n.usageGuideStep4Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep5,
                      l10n.usageGuideStep5Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep6,
                      l10n.usageGuideStep6Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep7,
                      l10n.usageGuideStep7Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      l10n.usageGuideStep8,
                      l10n.usageGuideStep8Desc,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildTipsCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(String title, String description, BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.usageGuideTips,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.usageGuideTipsDesc,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}