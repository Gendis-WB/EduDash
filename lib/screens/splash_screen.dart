import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Warna Biru Cerah Modern & Minimalis
    const Color primaryBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Ikon dengan Sudut Melengkung + Bayangan Halus
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    28,
                  ), // Sudut melengkung halus
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    28,
                  ), // Memotong gambar agar ikut melengkung
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 108, // Ukuran diperkecil agar pas
                    height: 108,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 32), // Spasi yang lebih proporsional
              // 2. Judul Aplikasi "EduDash"
              const Text(
                'EduDash',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5, // Tipografi modern khas Jakarta Sans
                ),
              ),

              const SizedBox(height: 8),

              // 3. Tagline Khas EduDash
              const Text(
                'Belajar Lebih, Raih Mimpi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDBEAFE), // Teks putih kebiruan lembut
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
