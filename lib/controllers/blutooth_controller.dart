import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> scanResults = [];

  // Check and request permissions
  Future<void> _checkPermissions() async {
    var status = await Permission.bluetoothScan.status;
    if (!status.isGranted) {
      await Permission.bluetoothScan.request();
    }

    status = await Permission.bluetoothConnect.status;
    if (!status.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _startScan(); // Start scanning when the app initializes
  }

  // Start scanning for Bluetooth devices
  void _startScan() async {
    // Check if Bluetooth is on before scanning
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState != BluetoothAdapterState.on) {
      print('Bluetooth is off. Please turn on Bluetooth.');
      return;
    }

    // Clear previous scan results
    setState(() {
      //scanResults.clear();
    });

    // Start scanning for devices
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results from the scanResults stream
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results; // Update the scan results list
      });
    });

    // Stop scanning after the timeout
    await Future.delayed(const Duration(seconds: 4));
    FlutterBluePlus.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Beacon Detector"),
      ),
      body: Column(
        children: <Widget>[
          // Display scanned Bluetooth devices
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final device = scanResults[index].device;
                return ListTile(
                  title: Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
                  subtitle: Text(device.remoteId.toString()), // Shows the device ID
                  trailing: Text('RSSI: ${scanResults[index].rssi}'), // RSSI value of the device
                );
              },
            ),
          ),
          // Button to trigger scanning again
          ElevatedButton(
            onPressed: _startScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
            ),
            child: const Text('Scan Again'),
          ),
        ],
      ),
    );
  }
}
