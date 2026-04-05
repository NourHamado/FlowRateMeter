import 'package:flutter/material.dart';
import 'summary_page.dart';

void main() {
  runApp(const FlowMeterApp());
}

class FlowMeterApp extends StatelessWidget {
  const FlowMeterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flow Meter',
      theme: ThemeData(
        fontFamily: 'DMSans', // ← default font for the app
        primaryColor: const Color(0xFF3B82F6),
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const SummaryPage(),
    );
  }
}
