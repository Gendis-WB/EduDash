import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'Indonesia';

  String get currentLanguage => _currentLanguage;
  bool get isEnglish => _currentLanguage == 'English';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('profile_language') ?? 'Indonesia';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_language', language);
    notifyListeners(); // Menyuruh seluruh aplikasi merender ulang dengan bahasa baru!
  }

  // Fungsi penerjemah instan
  String translate(String idText, String enText) {
    return isEnglish ? enText : idText;
  }
}
