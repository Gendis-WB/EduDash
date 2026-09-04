import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart'; // 1. IMPORT LANGUAGE PROVIDER
import 'providers/schedule_provider.dart'; // <-- 1. Import file baru
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    // PERBAIKAN: Membungkus aplikasi dengan MultiProvider agar "Gudang Data" aktif
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ), // 2. TAMBAHKAN KE DAFTAR
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(),
        ), // <-- 2. Daftarkan di sini
      ],
      child: const EduDashApp(),
    ),
  );
}

class EduDashApp extends StatelessWidget {
  const EduDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. PANTAU PERUBAHAN TEMA SECARA REAL-TIME
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'EduDash',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // 4. GUNAKAN TEMA DARI PROVIDER, BUKAN LAGI STATIS!
      themeMode: themeProvider.themeMode,

      home: const SplashScreen(),
    );
  }
}
