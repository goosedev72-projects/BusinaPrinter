import 'package:flutter/material.dart';
import 'package:busina_print_app/core/ble/printer_ble_service.dart';
import 'package:busina_print_app/core/utils/ble_commands.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:convert';

class BleTesterPage extends StatefulWidget {
  const BleTesterPage({Key? key}) : super(key: key);

  @override
  _BleTesterPageState createState() => _BleTesterPageState();
}

class _BleTesterPageState extends State<BleTesterPage> {
  final PrinterBleService _bleService = PrinterBleService();
  String _status = 'Disconnected';
  String _logText = '';
  final ScrollController _logController = ScrollController();
  TextEditingController _deviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set up notification callback via the universal_ble API
    UniversalBle.onValueChange = (deviceId, characteristicId, value) {
      if (_bleService.isConnected && 
          _bleService.connectedDeviceId != null && 
          deviceId == _bleService.connectedDeviceId) {
        _handleNotification(value);
      }
    };
  }

  @override
  void dispose() {
    UniversalBle.onValueChange = null;
    _bleService.disconnect();
    super.dispose();
  }

  void _handleNotification(Uint8List data) {
    _addLog('Received notification: ${_formatBytes(data)}');
  }

  void _addLog(String message) {
    setState(() {
      _logText += '${DateTime.now().toString()}: $message\n';
    });
    
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logController.jumpTo(_logController.position.maxScrollExtent);
    });
  }

  Future<void> _connect() async {
    if (_bleService.isConnected) {
      _addLog('Already connected');
      return;
    }

    setState(() {
      _status = 'Connecting...';
    });

    final success = await _bleService.findAndConnect(
      deviceName: _deviceNameController.text.isEmpty ? null : _deviceNameController.text,
    );

    if (success) {
      // Discover services after connection
      bool serviceDiscovered = await _bleService.discoverPrinterService();
      if (serviceDiscovered) {
        setState(() {
          _status = 'Connected';
        });
        _addLog('Successfully connected to printer');
      } else {
        setState(() {
          _status = 'Connected but service not discovered';
        });
        _addLog('Failed to discover printer service');
      }
    } else {
      setState(() {
        _status = 'Connection failed';
      });
      _addLog('Failed to connect to printer');
    }
  }

  Future<void> _disconnect() async {
    await _bleService.disconnect();
    setState(() {
      _status = 'Disconnected';
    });
    _addLog('Disconnected from printer');
  }

  Future<void> _sendTestPrint() async {
    if (!_bleService.isConnected) {
      _addLog('Not connected to printer');
      return;
    }

    try {
      // Simple test command - print a small pattern
      final testCommands = <int>[
        ...BleCommands.CMD_GET_DEV_STATE,
        ...BleCommands.CMD_SET_QUALITY_3,
        ...BleCommands.cmdSetEnergy(0x4000), // Medium energy
        ...BleCommands.cmdApplyEnergy(),
        ...BleCommands.CMD_LATTICE_START,
        // Send a simple 8x8 pattern (each row as 1 byte)
        for (int i = 0; i < 8; i++)
          ...BleCommands.cmdPrintRow([true, false, true, false, true, false, true, false]).toList(),
        ...BleCommands.cmdFeedPaper(25),
        ...BleCommands.CMD_SET_PAPER,
        ...BleCommands.CMD_LATTICE_END,
        ...BleCommands.CMD_GET_DEV_STATE,
      ];
      
      _addLog('Sending test print command (${testCommands.length} bytes)...');
      bool success = await _bleService.sendPrintCommands(testCommands);
      
      if (success) {
        _addLog('✅ Test print command sent successfully');
      } else {
        _addLog('❌ Failed to send test print command');
      }
    } catch (e) {
      _addLog('Error sending test print: $e');
    }
  }

  Future<void> _getPrinterState() async {
    if (!_bleService.isConnected) {
      _addLog('Not connected to printer');
      return;
    }

    final result = await _bleService.getPrinterState();
    if (result != null) {
      _addLog('Printer state request sent: ${result['message']}');
    } else {
      _addLog('Failed to get printer state');
    }
  }

  Future<void> _getPrinterInfo() async {
    if (!_bleService.isConnected) {
      _addLog('Not connected to printer');
      return;
    }

    final result = await _bleService.getPrinterInfo();
    if (result != null) {
      _addLog('Printer info request sent: ${result['message']}');
    } else {
      _addLog('Failed to get printer info');
    }
  }

  String _formatBytes(Uint8List bytes) {
    return bytes.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Printer Tester'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Status: $_status', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _deviceNameController,
                      decoration: const InputDecoration(
                        labelText: 'Device Name (optional)',
                        hintText: 'GT01, GB03, etc.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _bleService.isConnected ? null : _connect,
                          child: const Text('Connect'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _bleService.isConnected ? _disconnect : null,
                          child: const Text('Disconnect'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _bleService.isConnected ? _sendTestPrint : null,
                          child: const Text('Send Test Print'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _bleService.isConnected ? _getPrinterState : null,
                          child: const Text('Get State'),
                        ),
                        ElevatedButton(
                          onPressed: _bleService.isConnected ? _getPrinterInfo : null,
                          child: const Text('Get Info'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Log:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: ListView.builder(
                      controller: _logController,
                      itemCount: _logText.split('\n').length - 1,
                      itemBuilder: (context, index) {
                        final lines = _logText.split('\n');
                        if (index < lines.length - 1) {
                          return Text(lines[index]);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
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