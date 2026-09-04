import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _themePreference = 'Default';

  String get themePreference => _themePreference;

  // Menerjemahkan teks menjadi mode tema bawaan Flutter
  ThemeMode get themeMode {
    if (_themePreference == 'Terang') return ThemeMode.light;
    if (_themePreference == 'Gelap') return ThemeMode.dark;
    return ThemeMode.system; // Mengikuti pengaturan bawaan HP
  }

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Membaca dari kunci memori yang sama dengan Halaman Profil
    _themePreference = prefs.getString('profile_theme') ?? 'Default';
    notifyListeners();
  }

  Future<void> setTheme(String value) async {
    _themePreference = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_theme', value);
    notifyListeners(); // Menyuruh seluruh aplikasi untuk merender ulang layarnya!
  }
}
