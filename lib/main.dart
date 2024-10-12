// import 'package:bluetooth_beacons_app/controlers/blutooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:todo_demo/controllers/blutooth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Beacon Detector',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}