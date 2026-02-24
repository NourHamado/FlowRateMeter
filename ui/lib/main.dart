import 'package:flutter/material.dart';
import 'summary-page.dart';


void main() {
  runApp(const FlowMeterApp());
}

class FlowMeterApp extends StatelessWidget {
  const FlowMeterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Meter',
      home: const SummaryPage(),
    );
  }
}
