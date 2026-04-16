import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'summary_page.dart';
import 'language_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlowMeterApp());
}

class FlowMeterApp extends StatefulWidget {
  const FlowMeterApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _FlowMeterAppState? state = context.findAncestorStateOfType<_FlowMeterAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<FlowMeterApp> createState() => _FlowMeterAppState();
}

class _FlowMeterAppState extends State<FlowMeterApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flow Meter',
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      localizationsDelegates: [
        LanguageLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
