import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/screens/court_hearings_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSRemindersScreen extends StatefulWidget {
  const APMSRemindersScreen({super.key});

  @override
  State<APMSRemindersScreen> createState() => _APMSRemindersScreenState();
}

class _APMSRemindersScreenState extends State<APMSRemindersScreen> {
  List<Map<String, dynamic>> _allReminders = [];
  bool _isLoading = true;

  Color _parseColor(dynamic val, Color defaultColor) {
    if (val is Color) return val;
    if (val is String) {
      final cleaned = val.replaceAll('#', '').replaceAll('0x', '');
      final parsed = int.tryParse(cleaned, radix: 16);
      if (parsed != null) {
        if (cleaned.length == 6) {
          return Color(parsed + 0xFF000000);
        }
        return Color(parsed);
      }
    }
    return defaultColor;
  }

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  void _fetchReminders() async {
    final data = await ApiService.getReminders();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (data.isNotEmpty) {
          _allReminders = data;
        } else {
          _allReminders = List<Map<String, dynamic>>.from(_mockReminders);
        }
      });
    }
  }

  void _toggleReminder(String title, bool isCompleted) async {
    final success = await ApiService.toggleReminderCompletion(title, isCompleted);
    if (success) {
      _fetchReminders();
    }
  }

  void _deleteReminder(String title) async {
    final success = await ApiService.deleteReminder(title);
    if (success) {
      _fetchReminders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully.')),
        );
      }
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priorityController = TextEditingController();
    final tagController = TextEditingController();
    final detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title', hintText: 'e.g. File Bail Application'),
              ),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: 'Priority', hintText: 'High, Medium, or Low'),
              ),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(labelText: 'Tag', hintText: 'e.g. Case, Hearing, Billing'),
              ),
              TextField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'Details / Subtitle', hintText: 'e.g. Client: Priya Mehta'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final priority = priorityController.text.trim();
                final tag = tagController.text.trim();
                final details = detailController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task Title is required.')),
                  );
                  return;
                }

                // Determine priority colors
                String pBg = '0xFFF3F4F6';
                String pText = '0xFF4B5563';
                if (priority.toLowerCase() == 'high') {
                  pBg = '0xFFFEE2E2';
                  pText = '0xFFDC2626';
                } else if (priority.toLowerCase() == 'medium') {
                  pBg = '0xFFFEF3C7';
                  pText = '0xFFD97706';
                }

                // Determine tag colors
                String tBg = '0xFFEFF6FF';
                String tText = '0xFF2563EB';
                if (tag.toLowerCase() == 'hearing') {
                  tBg = '0xFFF5F3FF';
                  tText = '0xFF7C3AED';
                } else if (tag.toLowerCase() == 'billing') {
                  tBg = '0xFFECFDF5';
                  tText = '0xFF059669';
                }

                final taskData = {
                  'title': title,
                  'priority': priority.isEmpty ? 'Low' : priority,
                  'priorityBg': pBg,
                  'priorityText': pText,
                  'time': 'Jul 20, 2026 @ 10:00 AM',
                  'tag': tag.isEmpty ? 'Case' : tag,
                  'tagBg': tBg,
                  'tagText': tText,
                  'subtitle': details.isEmpty ? 'Pending' : details,
                  'isCompleted': false,
                };

                final success = await ApiService.addReminder(taskData);
                if (success) {
                  _fetchReminders();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save task to server.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context, String title) {
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reschedule Task', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: timeController,
            decoration: const InputDecoration(
              labelText: 'New Time / Date',
              hintText: 'e.g. Jul 22, 2026 @ 02:00 PM',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTime = timeController.text.trim();
                if (newTime.isEmpty) return;

                final success = await ApiService.updateReminder(title, {'time': newTime});
                if (success) {
                  _fetchReminders();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task rescheduled successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to reschedule task.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Reschedule'),
            ),
          ],
        );
      },
    );
  }

  final List<Map<String, dynamic>> _mockReminders = const [
    {
      'title': 'File Bail Application',
      'priority': 'High',
      'priorityBg': '0xFFFEE2E2',
      'priorityText': '0xFFDC2626',
      'time': 'Today • 02:00 PM',
      'tag': 'Case',
      'tagBg': '0xFFEFF6FF',
      'tagText': '0xFF2563EB',
      'subtitle': 'Client: Priya Mehta • City Sessions Court',
      'isCompleted': false,
    },
    {
      'title': 'Prepare Cross Examination',
      'priority': 'Medium',
      'priorityBg': '0xFFFEF3C7',
      'priorityText': '0xFFD97706',
      'time': 'Jul 17, 10:00 AM',
      'tag': 'Hearing',
      'tagBg': '0xFFF5F3FF',
      'tagText': '0xFF7C3AED',
      'subtitle': 'Client: Rajan Sharma • Bombay HC',
      'isCompleted': false,
    },
    {
      'title': 'Collect Document Copies',
      'priority': 'Low',
      'priorityBg': '0xFFF3F4F6',
      'priorityText': '0xFF4B5563',
      'time': 'Jul 18, 04:00 PM',
      'tag': 'Case',
      'tagBg': '0xFFEFF6FF',
      'tagText': '0xFF2563EB',
      'subtitle': 'Client: Sunita Rao • Office',
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    return ResponsiveLayout(
      mobileLayout: _buildMobileLayout(context),
      desktopLayout: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final pendingCount = _allReminders.where((r) => r['isCompleted'] != true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      GestureDetector(
                        onTap: () => _showAddTaskDialog(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: const [
                              Icon(Icons.add, color: Colors.black, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reminders & Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You have $pendingCount pending tasks today',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  itemCount: _allReminders.length,
                  itemBuilder: (context, index) {
                    return _buildMobileReminderCard(_allReminders[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.grid_view_rounded, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(Icons.gavel_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const APMSCourtHearingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const APMSCalendarScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const APMSNotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const APMSProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return DesktopLayoutWrapper(
      activeMenu: 'Tasks',
      child: Theme(
        data: ThemeData(
          brightness: Brightness.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reminders & Tasks',
                    style: TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showAddTaskDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      '+ Add Task',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildDesktopRemindersGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopRemindersGrid() {
    List<Widget> leftCol = [];
    List<Widget> rightCol = [];
    for (int i = 0; i < _allReminders.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(_buildDesktopReminderCard(_allReminders[i]));
      } else {
        rightCol.add(_buildDesktopReminderCard(_allReminders[i]));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: leftCol,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rightCol,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileReminderCard(Map<String, dynamic> item) {
    final title = item['title'] as String? ?? 'N/A';
    final priority = item['priority'] as String? ?? 'Low';
    final priorityBg = item['priorityBg'] != null
        ? _parseColor(item['priorityBg'], const Color(0xFFF3F4F6))
        : const Color(0xFFF3F4F6);
    final priorityTextColor = item['priorityText'] != null
        ? _parseColor(item['priorityText'], const Color(0xFF4B5563))
        : const Color(0xFF4B5563);
    final time = item['time'] as String? ?? 'N/A';
    final tag = item['tag'] as String? ?? 'Case';
    final tagBg = item['tagBg'] != null
        ? _parseColor(item['tagBg'], const Color(0xFFEFF6FF))
        : const Color(0xFFEFF6FF);
    final tagTextColor = item['tagText'] != null
        ? _parseColor(item['tagText'], const Color(0xFF2563EB))
        : const Color(0xFF2563EB);
    final subtitle = item['subtitle'] as String? ?? 'Pending';
    final isCompleted = item['isCompleted'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF0F1E36),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF9CA3AF), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleReminder(title, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Complete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRescheduleDialog(context, title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: const Color(0xFF374151),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reschedule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _deleteReminder(title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      foregroundColor: const Color(0xFFDC2626),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Delete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopReminderCard(Map<String, dynamic> item) {
    final title = item['title'] as String? ?? 'N/A';
    final priority = item['priority'] as String? ?? 'Low';
    final priorityBg = item['priorityBg'] != null
        ? _parseColor(item['priorityBg'], const Color(0xFFF3F4F6))
        : const Color(0xFFF3F4F6);
    final priorityTextColor = item['priorityText'] != null
        ? _parseColor(item['priorityText'], const Color(0xFF4B5563))
        : const Color(0xFF4B5563);
    final time = item['time'] as String? ?? 'N/A';
    final tag = item['tag'] as String? ?? 'Case';
    final tagBg = item['tagBg'] != null
        ? _parseColor(item['tagBg'], const Color(0xFFEFF6FF))
        : const Color(0xFFEFF6FF);
    final tagTextColor = item['tagText'] != null
        ? _parseColor(item['tagText'], const Color(0xFF2563EB))
        : const Color(0xFF2563EB);
    final subtitle = item['subtitle'] as String? ?? 'Pending';
    final isCompleted = item['isCompleted'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF0F1E36),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF9CA3AF), size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleReminder(title, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Complete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRescheduleDialog(context, title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: const Color(0xFF374151),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reschedule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _deleteReminder(title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      foregroundColor: const Color(0xFFDC2626),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Delete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
