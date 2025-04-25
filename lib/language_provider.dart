import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default locale is English
  final List<Locale> _supportedLocales = [
    const Locale('en'), // English
    const Locale('es'), // Spanish
    const Locale('fr'), // French
    const Locale('de'), // German
    const Locale('he'), // Hebrew
  ];

  final _languages = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'he': 'עברית',
    };

  Locale getLocale() => _locale;

  List<Locale> getSupportedLocales() => _supportedLocales;

  Map<String, String> getSupportedLanguages() => _languages;

  void setLocale(Locale newLocale) {
    if (_supportedLocales.contains(newLocale)) _locale = newLocale;
    notifyListeners();
  }
}