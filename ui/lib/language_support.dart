import 'package:flutter/material.dart';

class LanguageLocalizations {
  LanguageLocalizations(this.locale);

  final Locale locale;

  static LanguageLocalizations of(BuildContext context) {
    return Localizations.of<LanguageLocalizations>(context, LanguageLocalizations)!;
  }

  static const LocalizationsDelegate<LanguageLocalizations> delegate =
      _LanguageLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'dashboard': 'Dashboard',
      'flowmeter_usage': 'FlowMeter Usage',
      'total_volume': 'Total Volume',
      'flow_rate': 'Flow Rate',
      'average_flow_rate': 'Average Flow Rate',
      'go_to_summary': 'Go to Summary',
      'go_to_dashboard': 'Go to Dashboard',
      'home': 'Home',
      'settings': 'Settings',
      'welcome_back': 'Welcome back!',
      'flowmeter_summary': 'FlowMeter Summary',
      'last_updated': 'Last updated on',
      'at': 'at',
      'est': 'EST',
      'volume': 'Volume',
      'ml_water_used': 'mL water used',
      'ml_per_min': 'mL/min',
      'language': 'Language',
      'english': 'English',
      'spanish': 'Español',
      'no_data_available': 'No data available',
      'retry': 'Retry',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
    },
    'es': {
      'dashboard': 'Panel de Control',
      'flowmeter_usage': 'Uso de FlowMeter',
      'total_volume': 'Volumen Total',
      'flow_rate': 'Caudal',
      'average_flow_rate': 'Caudal Promedio',
      'go_to_summary': 'Ir a Resumen',
      'go_to_dashboard': 'Ir al Panel',
      'home': 'Inicio',
      'settings': 'Configuración',
      'welcome_back': '¡Bienvenido de nuevo!',
      'flowmeter_summary': 'Resumen de FlowMeter',
      'last_updated': 'Última actualización',
      'at': 'a las',
      'est': 'EST',
      'volume': 'Volumen',
      'ml_water_used': 'mL de agua utilizada',
      'ml_per_min': 'mL/min',
      'language': 'Idioma',
      'english': 'English',
      'spanish': 'Español',
      'no_data_available': 'No hay datos disponibles',
      'retry': 'Reintentar',
      'weekly': 'Semanal',
      'monthly': 'Mensual',
      'yearly': 'Anual',
    },
  };

  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get flowmeterUsage => _localizedValues[locale.languageCode]!['flowmeter_usage']!;
  String get totalVolume => _localizedValues[locale.languageCode]!['total_volume']!;
  String get flowRate => _localizedValues[locale.languageCode]!['flow_rate']!;
  String get averageFlowRate => _localizedValues[locale.languageCode]!['average_flow_rate']!;
  String get goToSummary => _localizedValues[locale.languageCode]!['go_to_summary']!;
  String get goToDashboard => _localizedValues[locale.languageCode]!['go_to_dashboard']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcome_back']!;
  String get flowmeterSummary => _localizedValues[locale.languageCode]!['flowmeter_summary']!;
  String get lastUpdated => _localizedValues[locale.languageCode]!['last_updated']!;
  String get at => _localizedValues[locale.languageCode]!['at']!;
  String get est => _localizedValues[locale.languageCode]!['est']!;
  String get volume => _localizedValues[locale.languageCode]!['volume']!;
  String get mlWaterUsed => _localizedValues[locale.languageCode]!['ml_water_used']!;
  String get mlPerMin => _localizedValues[locale.languageCode]!['ml_per_min']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get spanish => _localizedValues[locale.languageCode]!['spanish']!;
  String get noDataAvailable => _localizedValues[locale.languageCode]!['no_data_available']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get weekly => _localizedValues[locale.languageCode]!['weekly']!;
  String get monthly => _localizedValues[locale.languageCode]!['monthly']!;
  String get yearly => _localizedValues[locale.languageCode]!['yearly']!;
}

class _LanguageLocalizationsDelegate
    extends LocalizationsDelegate<LanguageLocalizations> {
  const _LanguageLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<LanguageLocalizations> load(Locale locale) {
    return Future.value(LanguageLocalizations(locale));
  }

  @override
  bool shouldReload(_LanguageLocalizationsDelegate old) {
    return false;
  }
}