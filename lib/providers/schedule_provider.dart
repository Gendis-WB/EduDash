import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleProvider with ChangeNotifier {
  List<Map<String, dynamic>> _schedules = [];

  List<Map<String, dynamic>> get schedules => _schedules;

  ScheduleProvider() {
    loadSchedules();
  }

  // 1. MEMBACA MEMORI LOKAL
  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? schedulesString = prefs.getString('edudash_schedules');

    if (schedulesString != null) {
      final List<dynamic> decoded = json.decode(schedulesString);

      _schedules = decoded.map((item) {
        return {
          'id': item['id'],
          'day': item['day'],
          'dayIndex':
              item['dayIndex'], // <-- PERBAIKAN: Data Index Hari Dimuat!
          'subject': item['subject'],
          'time': item['time'],
          'location': item['location'],
          'lecturer': item['lecturer'],

          'icon': Icons.menu_book,
          'color': Color(item['colorValue'] as int),
        };
      }).toList();

      notifyListeners();
    }
  }

  // 2. MENYIMPAN KE MEMORI LOKAL
  Future<void> saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    final String encoded = json.encode(
      _schedules
          .map(
            (s) => {
              'id': s['id'],
              'day': s['day'],
              'dayIndex':
                  s['dayIndex'], // <-- PERBAIKAN: Data Index Hari Disimpan!
              'subject': s['subject'],
              'time': s['time'],
              'location': s['location'],
              'lecturer': s['lecturer'],

              // Menggunakan .value agar aman dari error versi Flutter
              'colorValue': (s['color'] as Color).value,
            },
          )
          .toList(),
    );

    await prefs.setString('edudash_schedules', encoded);
  }

  // 3. OPERASI CRUD JADWAL
  void addSchedule(Map<String, dynamic> schedule) {
    _schedules.add(schedule);

    _schedules.sort(
      (a, b) => (a['time'] as String).compareTo(b['time'] as String),
    );

    saveSchedules();
    notifyListeners();
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s['id'] == id);

    saveSchedules();
    notifyListeners();
  }
}
