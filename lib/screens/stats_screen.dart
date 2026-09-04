import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/notification_sheet.dart';
// Memanggil Custom Widget yang sudah kita buat sebelumnya
import '../widgets/metric_card.dart';
import '../widgets/subject_progress_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final List<double> _weeklyTasksCompleted = [1, 3, 5, 2, 4, 6, 3];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.scaffoldBackgroundColor
        : const Color(0xFFF8FAFC);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    // FASE 2: Otomatisasi Data dari Provider
    final taskProvider = context.watch<TaskProvider>();
    final currentStreak = taskProvider.currentStreak;
    final completedTasks = taskProvider.completedTasks.length;
    final totalTasks = taskProvider.tasks.length;
    final completionRate = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).toInt();

    // Logika menghitung performa per mata pelajaran
    Map<String, List<int>> subjectStats = {};
    for (var task in taskProvider.tasks) {
      String subject = task['subject'];
      if (!subjectStats.containsKey(subject)) {
        subjectStats[subject] = [0, 0]; // Index 0: Selesai, Index 1: Total
      }
      subjectStats[subject]![1] += 1;
      if (task['isCompleted']) {
        subjectStats[subject]![0] += 1;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Statistik Belajar',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.bar_chart,
                            color: Color(0xFF2563EB),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Analisis performa akademikmu',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E3A8A)
                          : const Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_active_outlined,
                        color: isDark
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF2563EB),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const NotificationSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 2. GRID METRIK (Memakai Custom Widget MetricCard)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 1.25,
                children: [
                  MetricCard(
                    title: 'Total Tugas',
                    value: '$totalTasks Tugas',
                    subtext: 'Tercatat di sistem',
                    subtextColor: const Color(0xFF2563EB),
                    icon: Icons.assignment,
                    iconColor: const Color(0xFF2563EB),
                  ),
                  MetricCard(
                    title: 'Tugas Selesai',
                    value: '$completionRate%',
                    subtext: '$completedTasks dari $totalTasks tugas',
                    subtextColor: secondaryTextColor,
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF16A34A),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. STREAK HARIAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.03,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak Harian 🔥',
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$currentStreak Hari',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Terus kerjakan tugas setiap hari!',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFD97706),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        size: 40,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 4. CHART AKTIVITAS
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.03,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aktivitas Penyelesaian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          'Tugas/Hari',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChartBar(
                            'Sen',
                            _weeklyTasksCompleted[0] / 6,
                            false,
                            secondaryTextColor,
                          ),
                          _buildChartBar(
                            'Sel',
                            _weeklyTasksCompleted[1] / 6,
                            false,
                            secondaryTextColor,
                          ),
                          _buildChartBar(
                            'Rab',
                            _weeklyTasksCompleted[2] / 6,
                            false,
                            secondaryTextColor,
                          ),
                          _buildChartBar(
                            'Kam',
                            _weeklyTasksCompleted[3] / 6,
                            false,
                            secondaryTextColor,
                          ),
                          _buildChartBar(
                            'Jum',
                            _weeklyTasksCompleted[4] / 6,
                            false,
                            secondaryTextColor,
                          ),
                          _buildChartBar(
                            'Sab',
                            _weeklyTasksCompleted[5] / 6,
                            true,
                            const Color(0xFF2563EB),
                          ),
                          _buildChartBar(
                            'Min',
                            _weeklyTasksCompleted[6] / 6,
                            false,
                            secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 5. PERFORMA MATA PELAJARAN (Memakai Custom Widget SubjectProgressCard)
              Text(
                'Performa Mata Pelajaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),

              if (subjectStats.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Belum ada data tugas.',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  ),
                )
              else
                ...subjectStats.entries.map((entry) {
                  String subjectName = entry.key;
                  int completed = entry.value[0];
                  int total = entry.value[1];
                  double progress = total == 0 ? 0 : completed / total;
                  int percentage = (progress * 100).toInt();

                  Color barColor = const Color(0xFF2563EB);
                  IconData subjectIcon = Icons.book;
                  if (subjectName.toLowerCase().contains('matematika')) {
                    barColor = const Color(0xFFDC2626);
                    subjectIcon = Icons.calculate;
                  } else if (subjectName.toLowerCase().contains('basis data')) {
                    barColor = const Color(0xFF16A34A);
                    subjectIcon = Icons.storage;
                  }

                  return SubjectProgressCard(
                    subject: subjectName,
                    percentage: progress,
                    scoreText: '$percentage%',
                    icon: subjectIcon,
                    color: barColor,
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk diagram batang (dipertahankan karena sangat spesifik untuk chart)
  Widget _buildChartBar(
    String day,
    double heightFactor,
    bool isHighlight,
    Color color,
  ) {
    final clampedHeight = heightFactor > 1.0 ? 1.0 : heightFactor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 90 * clampedHeight,
          decoration: BoxDecoration(
            color: isHighlight ? color : color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
