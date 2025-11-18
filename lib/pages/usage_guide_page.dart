import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'ble_tester_page.dart';

class UsageGuidePage extends StatelessWidget {
  const UsageGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.longText), // Using longText as "Usage Guide" 
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
                      'Complete Guide to Using Your Thermal Printer App',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BleTesterPage()),
                        );
                      },
                      icon: const Icon(Icons.bluetooth),
                      label: const Text('BLE Testing Tool'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '1. Prerequisites & Initial Setup',
                      '• Ensure your thermal printer is fully charged\n• Enable Bluetooth on your mobile device\n• Make sure the printer is turned on and in pairing mode\n• Install the Busina Print App from the app store\n• Grant necessary permissions when prompted',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '2. Connecting to Your Printer',
                      '• Open the Busina Print App\n• Look for the Bluetooth connection icon in the top-right corner\n• Tap the icon to start scanning for available printers\n• Select your printer from the list (common names: GT01, GT02, GB03, etc.)\n• Wait for the connection confirmation message\n• A green Bluetooth icon indicates a successful connection',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '3. Printing Images from Your Device',
                      '• Navigate to the main "Print" tab\n• Tap the "Select Image" button (camera icon) to choose from your photo gallery\n• Select the image you want to print\n• Preview the image in the app\n• Choose between normal print or rotated print (for longer prints)\n• Tap the "Print" button and wait for the printing process to complete\n• Note: Image quality can be adjusted in Settings before printing',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '4. Printing Text',
                      '• Go to the main "Print" tab\n• Find the text input section\n• Enter your text in the provided text field\n• Use the "Print Text" button for standard printing\n• Use "Horizontal Printing" for long, continuous text that extends the paper\n• Text formatting will be preserved based on your settings',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '5. Using Image Packs (Organizing Your Prints)',
                      '• Navigate to the "Packs" tab\n• Create new image packs or browse existing ones\n• Add images to packs for organized printing\n• Access and print images directly from your saved packs\n• Great for frequently printed images or themed collections',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '6. Customizing Print Settings',
                      '• Access settings via the gear icon in the top-right\n• Adjust print quality using the energy level setting:\n  - Higher energy: darker, more intense prints (uses more battery)\n  - Lower energy: lighter prints (conserves battery)\n• Select dithering algorithms for image processing:\n  - Floyd-Steinberg: good for general images\n  - Atkinson: good for line art and simple graphics\n  - Burkes: good middle ground\n  - Stucki: good for detailed images\n• Set number of copies for automatic repeated printing\n• Adjust threshold and inversion settings for optimal image results',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '7. Advanced Features',
                      '• Camera Integration: Take photos directly in the app for immediate printing\n• Image Rotation: Use the rotate feature for different print orientations\n• Printer Status: Check connection status and printer information\n• Disconnect: Safely disconnect from the printer when finished',
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildStepCard(
                      '8. Troubleshooting Common Issues',
                      '• Connection Problems:\n  - Ensure printer is powered on and in range\n  - Try turning Bluetooth off and on\n  - Restart the app\n  - Power cycle the printer (turn off and on)\n• Poor Print Quality:\n  - Adjust energy level in settings\n  - Try different dithering algorithms\n  - Check if printer has sufficient battery\n• Image Not Printing:\n  - Verify printer connection status\n  - Check image format (JPG, PNG supported)\n  - Ensure image isn\'t too large',
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
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Printer Tips & Best Practices',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• For best image results, use high-contrast images with clear subjects\n• Darker energy levels (8-10) produce intense prints but drain battery faster\n• Lighter energy levels (2-4) conserve battery but may produce faint prints\n• Long prints can take 2-5 minutes depending on complexity and size\n• For text printing, avoid very long lines; shorter, well-formatted text prints better\n• Store thermal paper in a cool, dry place to maintain print quality\n• Clean the printer head regularly for optimal performance\n• If prints are faint or streaked, consider replacing thermal paper roll\n• For continuous text printing, use the horizontal printing feature\n• Test print settings on a sample image before printing important documents',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}