import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  // Variabel untuk Streak
  int _currentStreak = 0;
  String _lastActiveDate = ''; // Menyimpan tanggal (format: YYYY-MM-DD)

  List<Map<String, dynamic>> get tasks => _tasks;
  List<Map<String, dynamic>> get pendingTasks =>
      _tasks.where((task) => !task['isCompleted']).toList();
  List<Map<String, dynamic>> get completedTasks =>
      _tasks.where((task) => task['isCompleted']).toList();

  int get currentStreak => _currentStreak;

  TaskProvider() {
    loadTasks();
  }

  // 1. MEMBACA MEMORI LOKAL (Tugas & Streak)
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    // Memuat Data Tugas
    final String? tasksString = prefs.getString('edudash_tasks');
    if (tasksString != null) {
      final List<dynamic> decodedTasks = json.decode(tasksString);
      _tasks = decodedTasks.map((item) {
        return {
          'id': item['id'],
          'title': item['title'],
          'subject': item['subject'],
          'time': item['time'],
          'originalTime': item['originalTime'],
          'difficultyColor': Color(item['difficultyColor']),
          'isCompleted': item['isCompleted'],
        };
      }).toList();
    }

    // Memuat Data Streak
    _currentStreak = prefs.getInt('edudash_streak') ?? 0;
    _lastActiveDate = prefs.getString('edudash_last_active') ?? '';

    notifyListeners();
  }

  // 2. MENYIMPAN MEMORI LOKAL (Tugas)
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTasks = json.encode(
      _tasks
          .map(
            (task) => {
              'id': task['id'],
              'title': task['title'],
              'subject': task['subject'],
              'time': task['time'],
              'originalTime': task['originalTime'],
              'difficultyColor': task['difficultyColor'].value,
              'isCompleted': task['isCompleted'],
            },
          )
          .toList(),
    );
    await prefs.setString('edudash_tasks', encodedTasks);
  }

  // 3. MENYIMPAN MEMORI LOKAL (Streak)
  Future<void> saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('edudash_streak', _currentStreak);
    await prefs.setString('edudash_last_active', _lastActiveDate);
  }

  // 4. LOGIKA PERHITUNGAN STREAK HARIAN
  void _updateStreakOnTaskCompletion() {
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (_lastActiveDate.isEmpty) {
      // Pengguna baru pertama kali menyelesaikan tugas
      _currentStreak = 1;
      _lastActiveDate = todayStr;
    } else {
      // Parsing tanggal terakhir aktif
      final lastDate = DateTime.parse(_lastActiveDate);
      final todayDate = DateTime.parse(todayStr);
      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        // Tepat 1 hari (Kemarin mengerjakan, hari ini mengerjakan lagi)
        _currentStreak += 1;
        _lastActiveDate = todayStr;
      } else if (difference > 1) {
        // Bolos lebih dari 1 hari, Streak hangus!
        _currentStreak = 1;
        _lastActiveDate = todayStr;
      }
      // Jika difference == 0 (Hari ini sudah mengerjakan tugas lain), streak tetap dan tidak diubah.
    }

    saveStreak(); // Kunci data streak ke memori
  }

  // 5. OPERASI TUGAS
  void addTask(Map<String, dynamic> task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final taskIndex = _tasks.indexWhere((task) => task['id'] == id);
    if (taskIndex != -1) {
      _tasks[taskIndex]['isCompleted'] = !_tasks[taskIndex]['isCompleted'];

      if (_tasks[taskIndex]['isCompleted']) {
        _tasks[taskIndex]['originalTime'] = _tasks[taskIndex]['time'];
        _tasks[taskIndex]['time'] = 'Selesai';

        // Panggil sistem kalkulasi Streak setiap kali tugas diselesaikan
        _updateStreakOnTaskCompletion();
      } else {
        _tasks[taskIndex]['time'] = _tasks[taskIndex]['originalTime'];
      }

      saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task['id'] == id);
    saveTasks();
    notifyListeners();
  }
}
