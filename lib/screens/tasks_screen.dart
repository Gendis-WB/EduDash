import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/notification_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Semua', 'Belum Selesai', 'Selesai'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variabel untuk menyimpan status filter kesulitan
  Color? _filterDifficultyColor;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // FUNGSI 1: Memunculkan Bottom Sheet untuk Filter
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
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
                    'Filter Tingkat Kesulitan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip('Semua', null, setModalState),
                      _buildFilterChip(
                        'Mudah',
                        const Color(0xFF16A34A),
                        setModalState,
                      ),
                      _buildFilterChip(
                        'Sedang',
                        const Color(0xFF2563EB),
                        setModalState,
                      ),
                      _buildFilterChip(
                        'Sulit',
                        const Color(0xFFDC2626),
                        setModalState,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper untuk membuat tombol di dalam filter sheet
  Widget _buildFilterChip(
    String label,
    Color? color,
    StateSetter setModalState,
  ) {
    final isSelected = _filterDifficultyColor == color;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color != null
          ? color.withValues(alpha: 0.2)
          : Colors.grey.withValues(alpha: 0.2),
      onSelected: (val) {
        setModalState(
          () => _filterDifficultyColor = color,
        ); // Update UI Bottom Sheet
        setState(
          () => _filterDifficultyColor = color,
        ); // Update UI Halaman Tugas
      },
    );
  }

  void _showAddTaskSheet() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();

    // Variabel untuk menyimpan tanggal deadline
    DateTime? selectedDeadline;

    Color selectedDifficulty = const Color(0xFF2563EB); // Sedang (Biru)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
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
                        'Tambah Tugas Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // INPUT JUDUL TUGAS
                      TextField(
                        controller: titleController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Judul Tugas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // INPUT MATA PELAJARAN
                      TextField(
                        controller: subjectController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mata Pelajaran',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DEADLINE - DATE PICKER
                      InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );

                          if (pickedDate != null) {
                            setModalState(() {
                              selectedDeadline = pickedDate;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? Colors.grey[600]! : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDeadline == null
                                    ? 'Pilih Deadline (Kalender)'
                                    : '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}',
                                style: TextStyle(
                                  color: selectedDeadline == null
                                      ? Colors.grey
                                      : isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF2563EB),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // TINGKAT KESULITAN
                      const Text(
                        'Tingkat Kesulitan:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ChoiceChip(
                            label: const Text('Mudah'),
                            selected:
                                selectedDifficulty == const Color(0xFF16A34A),
                            selectedColor: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.2),
                            onSelected: (val) {
                              setModalState(() {
                                selectedDifficulty = const Color(0xFF16A34A);
                              });
                            },
                          ),

                          ChoiceChip(
                            label: const Text('Sedang'),
                            selected:
                                selectedDifficulty == const Color(0xFF2563EB),
                            selectedColor: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.2),
                            onSelected: (val) {
                              setModalState(() {
                                selectedDifficulty = const Color(0xFF2563EB);
                              });
                            },
                          ),

                          ChoiceChip(
                            label: const Text('Sulit'),
                            selected:
                                selectedDifficulty == const Color(0xFFDC2626),
                            selectedColor: const Color(
                              0xFFDC2626,
                            ).withValues(alpha: 0.2),
                            onSelected: (val) {
                              setModalState(() {
                                selectedDifficulty = const Color(0xFFDC2626);
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // TOMBOL SIMPAN
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (titleController.text.isNotEmpty &&
                                subjectController.text.isNotEmpty &&
                                selectedDeadline != null) {
                              context.read<TaskProvider>().addTask({
                                'id': DateTime.now().millisecondsSinceEpoch
                                    .toString(),

                                'title': titleController.text,

                                'subject': subjectController.text,

                                // Deadline dari kalender
                                'time':
                                    '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}',

                                'difficultyColor': selectedDifficulty,

                                'isCompleted': false,
                              });

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Mohon lengkapi semua data, termasuk deadline.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Simpan Tugas',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.scaffoldBackgroundColor
        : const Color(0xFFF8FAFC);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]
        : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final taskProvider = context.watch<TaskProvider>();
    List<Map<String, dynamic>> displayTasks = [];

    // Filter Kategori Tab
    if (_selectedCategoryIndex == 0) {
      displayTasks = taskProvider.tasks;
    } else if (_selectedCategoryIndex == 1) {
      displayTasks = taskProvider.pendingTasks;
    } else {
      displayTasks = taskProvider.completedTasks;
    }

    // Filter Pencarian Teks
    if (_searchQuery.isNotEmpty) {
      displayTasks = displayTasks.where((task) {
        return task['title'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            task['subject'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // Filter Tingkat Kesulitan (DARI BOTTOM SHEET)
    if (_filterDifficultyColor != null) {
      displayTasks = displayTasks
          .where((task) => task['difficultyColor'] == _filterDifficultyColor)
          .toList();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3A8A)
                              : const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.task_alt,
                          color: isDark
                              ? const Color(0xFF60A5FA)
                              : const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Tugas Saya',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
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
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        style: TextStyle(color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: 'Cari tugas...',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: secondaryTextColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: _filterDifficultyColor != null
                          ? const Color(0xFF1E3A8A)
                          : const Color(
                              0xFF2563EB,
                            ), // Ganti warna sedikit jika filter aktif
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed:
                          _showFilterSheet, // <-- FUNGSI FILTER DIHUBUNGKAN
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2563EB) : cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : (isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : secondaryTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: displayTasks.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada tugas ditemukan.',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: displayTasks.length,
                      itemBuilder: (context, index) {
                        final task = displayTasks[index];
                        return Dismissible(
                          key: Key(task['id']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (direction) {
                            context.read<TaskProvider>().deleteTask(task['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Tugas dihapus'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          child: _buildTaskCard(
                            context: context,
                            id: task['id'],
                            title: task['title'],
                            subject: task['subject'],
                            time: task['time'],
                            difficultyColor: task['difficultyColor'],
                            isCompleted: task['isCompleted'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required String id,
    required String title,
    required String subject,
    required String time,
    required Color difficultyColor,
    required bool isCompleted,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]
        : const Color(0xFF64748B);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: difficultyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu_book, color: difficultyColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 12,
                    color: difficultyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // FUNGSI 2: LOGIKA DEADLINE HIJAU JIKA SELESAI
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.access_time,
                      size: 14,
                      color: isCompleted
                          ? const Color(0xFF16A34A)
                          : secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCompleted ? 'Selesai' : time,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted
                            ? const Color(0xFF16A34A)
                            : secondaryTextColor,
                        fontWeight: isCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: isCompleted,
              activeColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                width: 2,
              ),
              onChanged: (value) {
                context.read<TaskProvider>().toggleTaskStatus(id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
