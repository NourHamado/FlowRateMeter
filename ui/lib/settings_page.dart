import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_support.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late String selectedLanguage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language_code') ?? 'en';
      isLoading = false;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    
    setState(() {
      selectedLanguage = languageCode;
    });

    if (mounted) {
      FlowMeterApp.setLocale(context, Locale(languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final localizations = LanguageLocalizations.of(context);

    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xFFF0F9FF),
            Color(0xFFE0F2FE),
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Settings Header
                Text(
                  localizations.settings,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.language, size: 24, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 12),
                          Text(
                            localizations.language,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // English Option
                      _buildLanguageOption(
                        languageName: 'English',
                        flag: '🇺🇸',
                        isSelected: selectedLanguage == 'en',
                        onTap: () => _changeLanguage('en'),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Spanish Option
                      _buildLanguageOption(
                        languageName: 'Español',
                        flag: '🇪🇸',
                        isSelected: selectedLanguage == 'es',
                        onTap: () => _changeLanguage('es'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageName,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF3B82F6) : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}