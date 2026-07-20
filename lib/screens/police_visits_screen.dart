import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/fir_management_screen.dart';
import 'package:advocate_app/screens/investigation_tracker_screen.dart';
import 'package:advocate_app/screens/evidence_screen.dart';
import 'package:advocate_app/screens/case_details_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/screens/court_hearings_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSPoliceVisitsScreen extends StatefulWidget {
  const APMSPoliceVisitsScreen({super.key});

  @override
  State<APMSPoliceVisitsScreen> createState() => _APMSPoliceVisitsScreenState();
}

class _APMSPoliceVisitsScreenState extends State<APMSPoliceVisitsScreen> {
  List<Map<String, dynamic>> _allVisits = [];
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
    _fetchVisits();
  }

  void _fetchVisits() async {
    final data = await ApiService.getVisits();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (data.isNotEmpty) {
          _allVisits = data;
        } else {
          _allVisits = List<Map<String, dynamic>>.from(_mockVisits);
        }
      });
    }
  }

  void _showScheduleVisitDialog(BuildContext context) {
    final psController = TextEditingController();
    final ioController = TextEditingController();
    final caseController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Schedule Police Visit', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: psController,
                  decoration: const InputDecoration(labelText: 'Police Station Name', hintText: 'e.g. Andheri Police Station'),
                ),
                TextField(
                  controller: ioController,
                  decoration: const InputDecoration(labelText: 'Investigating Officer (IO)', hintText: 'e.g. IO Rajesh Patil'),
                ),
                TextField(
                  controller: caseController,
                  decoration: const InputDecoration(labelText: 'Case Info / No.', hintText: 'e.g. CR-2026-047'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date', hintText: 'e.g. Jan 10, 2026'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time', hintText: 'e.g. 02:00 PM'),
                ),
                TextField(
                  controller: purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose', hintText: 'e.g. Witness statement'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final ps = psController.text.trim();
                final io = ioController.text.trim();
                final caseInfo = caseController.text.trim();
                final date = dateController.text.trim();
                final time = timeController.text.trim();
                final purpose = purposeController.text.trim();

                if (ps.isEmpty || io.isEmpty || caseInfo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in Police Station, IO, and Case info.')),
                  );
                  return;
                }

                final visitData = {
                  'title': ps,
                  'subtitle': io,
                  'tagText': 'Scheduled',
                  'tagBgColor': '0xFFE0F2FE',
                  'tagTextColor': '0xFF0369A1',
                  'caseInfo': '$caseInfo . $date',
                  'timeInfo': '$time . $purpose',
                };

                final success = await ApiService.addVisit(visitData);
                if (success) {
                  _fetchVisits();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Police visit scheduled successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save visit to server.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCaseDetails(BuildContext context, String caseInfo) async {
    final caseNo = caseInfo.split(' . ').first.split(' • ').first.trim();
    final cases = await ApiService.getCases();
    Map<String, dynamic>? matchedCase;
    for (var c in cases) {
      if (c['caseNo']?.toString().toLowerCase().trim() == caseNo.toLowerCase()) {
        matchedCase = c;
        break;
      }
    }
    
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => APMSCaseDetailsScreen(
            caseData: matchedCase ?? {
              'caseNo': caseNo,
              'title': 'State vs. Client',
              'status': 'Active',
            },
          ),
        ),
      );
    }
  }

  void _showAddReminderDialogForVisit(BuildContext context, String title, String caseInfo) {
    final titleController = TextEditingController(text: 'Follow up on $title visit');
    final priorityController = TextEditingController(text: 'Medium');
    final tagController = TextEditingController(text: 'Case');
    final detailController = TextEditingController(text: 'Linked to $caseInfo');

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
                decoration: const InputDecoration(labelText: 'Task Title'),
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
                decoration: const InputDecoration(labelText: 'Details / Subtitle'),
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
                final t = titleController.text.trim();
                final priority = priorityController.text.trim();
                final tag = tagController.text.trim();
                final details = detailController.text.trim();

                if (t.isEmpty) return;

                // Priority colors
                String pBg = '0xFFF3F4F6';
                String pText = '0xFF4B5563';
                if (priority.toLowerCase() == 'high') {
                  pBg = '0xFFFEE2E2';
                  pText = '0xFFDC2626';
                } else if (priority.toLowerCase() == 'medium') {
                  pBg = '0xFFFEF3C7';
                  pText = '0xFFD97706';
                }

                // Tag colors
                String tBg = '0xFFEFF6FF';
                String tText = '0xFF2563EB';

                final taskData = {
                  'title': t,
                  'priority': priority.isEmpty ? 'Low' : priority,
                  'priorityBg': pBg,
                  'priorityText': pText,
                  'time': 'Today • 10:00 AM',
                  'tag': tag.isEmpty ? 'Case' : tag,
                  'tagBg': tBg,
                  'tagText': tText,
                  'subtitle': details,
                  'isCompleted': false,
                };

                final success = await ApiService.addReminder(taskData);
                if (success) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save task.')),
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

  void _showEditVisitDialog(
    BuildContext context,
    String currentTitle,
    String currentSubtitle,
    String currentCaseInfo,
    String currentTimeInfo,
  ) {
    final psController = TextEditingController(text: currentTitle);
    final ioController = TextEditingController(text: currentSubtitle);
    
    final caseParts = currentCaseInfo.split(' . ');
    final caseNo = caseParts.first;
    final date = caseParts.length > 1 ? caseParts.last : '';
    
    final timeParts = currentTimeInfo.split(' . ');
    final time = timeParts.first;
    final purpose = timeParts.length > 1 ? timeParts.last : '';

    final caseController = TextEditingController(text: caseNo);
    final dateController = TextEditingController(text: date);
    final timeController = TextEditingController(text: time);
    final purposeController = TextEditingController(text: purpose);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Police Visit', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: psController,
                  decoration: const InputDecoration(labelText: 'Police Station Name'),
                  enabled: false,
                ),
                TextField(
                  controller: ioController,
                  decoration: const InputDecoration(labelText: 'Investigating Officer (IO)'),
                ),
                TextField(
                  controller: caseController,
                  decoration: const InputDecoration(labelText: 'Case Info / No.'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                  controller: purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final io = ioController.text.trim();
                final caseInfoVal = caseController.text.trim();
                final dateVal = dateController.text.trim();
                final timeVal = timeController.text.trim();
                final purposeVal = purposeController.text.trim();

                final success = await ApiService.updateVisit(currentTitle, {
                  'subtitle': io,
                  'caseInfo': '$caseInfoVal . $dateVal',
                  'timeInfo': '$timeVal . $purposeVal',
                });

                if (success) {
                  _fetchVisits();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Police visit updated successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update visit on server.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  final List<Map<String, dynamic>> _mockVisits = const [
    {
      'title': 'Andheri Police Station',
      'subtitle': 'IO Ramesh Patil',
      'tagText': 'Scheduled',
      'tagBgColor': '0xFFE0F2FE',
      'tagTextColor': '0xFF0369A1',
      'caseInfo': 'CR-2026-047 . Jan 10, 2026',
      'timeInfo': '02:00 PM . Witness statement',
    },
    {
      'title': 'Bandra Police Station',
      'subtitle': 'IO Sandeep Kadam',
      'tagText': 'Completed',
      'tagBgColor': '0xFFDCFCE7',
      'tagTextColor': '0xFF15803D',
      'caseInfo': 'CR-2026-012 . Jan 08, 2026',
      'timeInfo': '11:00 AM . Accused interrogation',
    },
  ];

  Widget _buildTopTabs(BuildContext context, String currentTab) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildTabItem(context, 'Visits', currentTab == 'Visits', const APMSPoliceVisitsScreen()),
          _buildTabItem(context, 'FIR Management', currentTab == 'FIR Management', const APMSFIRManagementScreen()),
          _buildTabItem(context, 'Investigation', currentTab == 'Investigation', const APMSInvestigationTrackerScreen()),
          _buildTabItem(context, 'Evidence', currentTab == 'Evidence', const APMSEvidenceScreen()),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String label, bool isSelected, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => targetScreen,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFD1D5DB),
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Police Visits',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_allVisits.length} visits this month',
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
                              hintText: 'Search by Case or Title',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      _buildTopTabs(context, 'Visits'),
                      const SizedBox(height: 24),
                      ..._allVisits.map((v) {
                        return _buildVisitCard(
                          context: context,
                          title: v['title']?.toString() ?? 'N/A',
                          subtitle: v['subtitle']?.toString() ?? 'N/A',
                          tagText: v['tagText']?.toString() ?? 'Visit',
                          tagBgColor: _parseColor(v['tagBgColor'], const Color(0xFFE0F2FE)),
                          tagTextColor: _parseColor(v['tagTextColor'], const Color(0xFF0369A1)),
                          caseInfo: v['caseInfo']?.toString() ?? '',
                          timeInfo: v['timeInfo']?.toString() ?? '',
                        );
                      }),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF9CA3AF),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showScheduleVisitDialog(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Color(0xFF374151), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Schedule New Police Visit',
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    final visits = _allVisits.map((v) {
      return _buildVisitCard(
        context: context,
        title: v['title']?.toString() ?? 'N/A',
        subtitle: v['subtitle']?.toString() ?? 'N/A',
        tagText: v['tagText']?.toString() ?? 'Visit',
        tagBgColor: _parseColor(v['tagBgColor'], const Color(0xFFE0F2FE)),
        tagTextColor: _parseColor(v['tagTextColor'], const Color(0xFF0369A1)),
        caseInfo: v['caseInfo']?.toString() ?? '',
        timeInfo: v['timeInfo']?.toString() ?? '',
      );
    }).toList();

    List<Widget> leftCol = [];
    List<Widget> rightCol = [];
    for (int i = 0; i < visits.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(visits[i]);
      } else {
        rightCol.add(visits[i]);
      }
    }

    return DesktopLayoutWrapper(
      activeMenu: 'Police Visits',
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
                    'Police Visits',
                    style: TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showScheduleVisitDialog(context),
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
                      '+ Schedule Visit',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTopTabs(context, 'Visits'),
              const SizedBox(height: 32),
              Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String tagText,
    required Color tagBgColor,
    required Color tagTextColor,
    required String caseInfo,
    required String timeInfo,
  }) {
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F1E36),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Colors.grey, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  caseInfo,
                  style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time_outlined, color: Colors.grey, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  timeInfo,
                  style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _navigateToCaseDetails(context, caseInfo),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.navigation_outlined, color: Color(0xFF374151), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Navigate',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showAddReminderDialogForVisit(context, title, caseInfo),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Add Reminder',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showEditVisitDialog(context, title, subtitle, caseInfo, timeInfo),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Edit Visit',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
