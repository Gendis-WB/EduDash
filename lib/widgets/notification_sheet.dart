import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/schedule_provider.dart';

class NotificationSheet extends StatelessWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF64748B);

    // MENGAMBIL DATA DARI PROVIDER
    final taskProvider = context.watch<TaskProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();

    // LOGIKA WAKTU (Hari ini & Besok)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final todayName = days[now.weekday - 1];

    // FILTER JADWAL HARI INI
    final todaySchedules = scheduleProvider.schedules
        .where((s) => s['day'] == todayName)
        .toList();

    // FILTER TUGAS MENDESAK (Hari ini & Besok)
    final urgentTasks = taskProvider.pendingTasks.where((task) {
      final timeStr = task['time'] as String;
      if (timeStr == 'Kapan saja' || timeStr == 'Selesai') return false;
      try {
        final parts = timeStr.split('/');
        if (parts.length == 3) {
          final taskDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          return taskDate.isAtSameMomentAs(today) ||
              taskDate.isAtSameMomentAs(tomorrow);
        }
      } catch (e) {
        return false;
      }
      return false;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Notifikasi 🔔',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // BAGIAN JADWAL TERDEKAT
            Text(
              'Jadwal Kelas Hari Ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            todaySchedules.isEmpty
                ? Text(
                    'Tidak ada kelas hari ini.',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: todaySchedules
                        .map(
                          (schedule) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _buildNotificationItem(
                              icon: schedule['icon'],
                              iconColor: schedule['color'],
                              title: schedule['subject'],
                              subtitle:
                                  '${schedule['time']} • ${schedule['location']}',
                              isDark: isDark,
                            ),
                          ),
                        )
                        .toList(),
                  ),

            const SizedBox(height: 24),

            // BAGIAN TUGAS DEADLINE
            Text(
              'Tugas Mendekati Deadline',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            urgentTasks.isEmpty
                ? Text(
                    'Aman! Tidak ada tugas mendesak.',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Column(
                    children: urgentTasks
                        .map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: _buildNotificationItem(
                              icon: Icons.warning_amber_rounded,
                              iconColor: task['difficultyColor'],
                              title: task['title'],
                              subtitle:
                                  'Deadline: ${task['time']} • ${task['subject']}',
                              isDark: isDark,
                            ),
                          ),
                        )
                        .toList(),
                  ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.transparent : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
