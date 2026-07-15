import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/screens/case_details_screen.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/add_client_screen.dart';
import 'package:advocate_app/screens/add_case_screen.dart';
import 'package:advocate_app/screens/police_visits_screen.dart';
import 'package:advocate_app/screens/court_hearings_screen.dart';
import 'package:advocate_app/screens/reminders_screen.dart';
import 'package:advocate_app/screens/evidence_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSHomeScreen extends StatefulWidget {
  const APMSHomeScreen({super.key});

  @override
  State<APMSHomeScreen> createState() => _APMSHomeScreenState();
}

class _APMSHomeScreenState extends State<APMSHomeScreen> {
  int _activeCasesCount = 47;
  int _todayHearingsCount = 6;
  int _policeVisitsCount = 3;
  int _clientMeetingsCount = 4;
  final String _pendingPaymentsAmount = "₹2.4L";
  int _pendingTasksCount = 12;

  List<Map<String, dynamic>> _todaySchedule = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() async {
    final cases = await ApiService.getCases();
    final hearings = await ApiService.getHearings();
    final visits = await ApiService.getVisits();
    final reminders = await ApiService.getReminders();
    final clients = await ApiService.getClients();

    if (mounted) {
      setState(() {
        if (cases.isNotEmpty) {
          _activeCasesCount = cases.where((c) => c['status'] == 'Active').length;
        }
        if (hearings.isNotEmpty) {
          _todayHearingsCount = hearings.where((h) => h['isToday'] == true).length;
        }
        if (visits.isNotEmpty) {
          _policeVisitsCount = visits.where((v) => v['tagText'] != 'Completed').length;
        }
        if (clients.isNotEmpty) {
          _clientMeetingsCount = clients.length;
        }
        if (reminders.isNotEmpty) {
          _pendingTasksCount = reminders.where((r) => r['isCompleted'] == false).length;
        }
        
        // Let's populate the today's schedule section
        final List<Map<String, dynamic>> schedule = [];
        for (var h in hearings) {
          if (h['isToday'] == true) {
            schedule.add({
              'time': '${h['time'] ?? ''} ${h['period'] ?? ''}',
              'title': h['title'] as String,
              'subtitle': h['court'] as String,
              'tag': 'Hearing',
              'color': Colors.blue,
            });
          }
        }
        for (var v in visits) {
          if (v['tagText'] == 'Scheduled') {
            schedule.add({
              'time': (v['timeInfo'] as String).split(' . ').first,
              'title': v['title'] as String,
              'subtitle': v['subtitle'] as String,
              'tag': 'Police',
              'color': Colors.orange,
            });
          }
        }
        
        if (schedule.isNotEmpty) {
          _todaySchedule = schedule;
        } else {
          _todaySchedule = List<Map<String, dynamic>>.from(_mockSchedule);
        }
      });
    }
  }

  final List<Map<String, dynamic>> _mockSchedule = const [
    {
      'time': '10:30 AM',
      'title': 'Sharma vs State',
      'subtitle': 'Sessions Court – Hall 4',
      'tag': 'Hearing',
      'color': Colors.blue,
    },
    {
      'time': '02:00 PM',
      'title': 'FIR Review – Patel',
      'subtitle': 'Andheri PS – IO Desai',
      'tag': 'Police',
      'color': Colors.orange,
    },
    {
      'time': '04:30 PM',
      'title': 'Mehta Consultation',
      'subtitle': 'Office Meeting',
      'tag': 'Meeting',
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            // Dark Header Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Good Morning, Advocate',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Adv. Arjun Mehtha',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const APMSNotificationsScreen(),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSProfileScreen()),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=120',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey, size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search for a service...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
            // Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.light,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upcoming Hearing Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 12),
                                        SizedBox(width: 4),
                                        Text(
                                          'Upcoming Hearing',
                                          style: TextStyle(
                                            color: Color(0xFFEF4444),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Hearing Tomorrow Morning',
                                    style: TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: const [
                                      Icon(Icons.description_outlined, color: Color(0xFFEF4444), size: 14),
                                      SizedBox(width: 8),
                                      Text(
                                        'Case No: CR -2026-014',
                                        style: TextStyle(
                                          color: Color(0xFF4B5563),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: const [
                                      Icon(Icons.access_time_outlined, color: Color(0xFFEF4444), size: 14),
                                      SizedBox(width: 8),
                                      Text(
                                        '10:30AM  .  District Court',
                                        style: TextStyle(
                                          color: Color(0xFF4B5563),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: const [
                                      Icon(Icons.person_outline, color: Color(0xFFEF4444), size: 14),
                                      SizedBox(width: 8),
                                      Text(
                                        'Client : Ramesh Kumar',
                                        style: TextStyle(
                                          color: Color(0xFF4B5563),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFFEE2E2)),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.info_outline, color: Color(0xFFEF4444), size: 14),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Be prepared with documents before 9:30 AM.',
                                            style: TextStyle(
                                              color: Color(0xFFEF4444),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                ClipPath(
                                  clipper: const HexagonClipper(),
                                  child: Image.asset(
                                    'assets/images/4.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const APMSCaseDetailsScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.description_outlined, color: Colors.white, size: 12),
                                        SizedBox(width: 4),
                                        Text(
                                          'View Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'OVERVIEW',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OverviewCard(
                              icon: Icons.work_outline,
                              color: const Color(0xFFEFF6FF),
                              iconColor: Colors.blue,
                              value: _activeCasesCount.toString(),
                              label: 'Active Cases',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const APMSCourtHearingsScreen()),
                                );
                              },
                              child: OverviewCard(
                                icon: Icons.gavel_outlined,
                                color: const Color(0xFFF5F3FF),
                                iconColor: Colors.purple,
                                value: _todayHearingsCount.toString(),
                                label: 'Today\'s Hearings',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const APMSPoliceVisitsScreen()),
                                );
                              },
                              child: OverviewCard(
                                icon: Icons.shield_outlined,
                                color: const Color(0xFFFFF7ED),
                                iconColor: Colors.orange,
                                value: _policeVisitsCount.toString(),
                                label: 'Police Visits',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OverviewCard(
                              icon: Icons.people_outline,
                              color: const Color(0xFFECFDF5),
                              iconColor: const Color(0xFF10B981),
                              value: _clientMeetingsCount.toString(),
                              label: 'Client Meetings',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OverviewCard(
                              icon: Icons.currency_rupee,
                              color: const Color(0xFFFEF2F2),
                              iconColor: Colors.red,
                              value: _pendingPaymentsAmount,
                              label: 'Pending Payments',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const APMSRemindersScreen()),
                                );
                              },
                              child: OverviewCard(
                                icon: Icons.access_time,
                                color: const Color(0xFFFEFCE8),
                                iconColor: const Color(0xFFD97706),
                                value: _pendingTasksCount.toString(),
                                label: 'Pending Tasks',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'QUICK ACTIONS',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickActionButton(
                            icon: Icons.person_add_alt_1_outlined,
                            color: const Color(0xFFEFF6FF),
                            iconColor: Colors.blue,
                            label: 'Add Client',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSAddClientScreen()),
                              );
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.work_outline,
                            color: const Color(0xFFF5F3FF),
                            iconColor: Colors.purple,
                            label: 'Add Case',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSAddCaseScreen()),
                              );
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.description_outlined,
                            color: const Color(0xFFE0F2FE),
                            iconColor: Colors.lightBlue,
                            label: 'Documents',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSEvidenceScreen()),
                              );
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.shield_outlined,
                            color: const Color(0xFFFFF7ED),
                            iconColor: Colors.orange,
                            label: 'Police Visit',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSPoliceVisitsScreen()),
                              );
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.notifications_none_outlined,
                            color: const Color(0xFFE8F5E9),
                            iconColor: Colors.green,
                            label: 'Reminder',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const APMSRemindersScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TODAY\'S SCHEDULE',
                            style: TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._todaySchedule.map((item) {
                    return ScheduleItem(
                      time: item['time'] as String,
                      title: item['title'] as String,
                      subtitle: item['subtitle'] as String,
                      tag: item['tag'] as String,
                      color: item['color'] as Color,
                      tagBgColor: const Color(0xFFF3F4F6),
                      tagTextColor: const Color(0xFF4B5563),
                    );
                  }),
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
          icon: const Icon(Icons.grid_view_rounded, color: Colors.black, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.gavel_outlined, color: Color(0xFF9CA3AF), size: 26),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const APMSCasesScreen()),
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
              MaterialPageRoute(
                builder: (context) => const APMSNotificationsScreen(),
              ),
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
      activeMenu: 'Dashboard',
      child: Theme(
        data: ThemeData(
          brightness: Brightness.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Upcoming Hearing Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 13),
                                SizedBox(width: 6),
                                Text(
                                  'Upcoming Hearing',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Hearing Tomorrow Morning',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Icon(Icons.description_outlined, color: Color(0xFFEF4444), size: 15),
                              SizedBox(width: 8),
                              Text(
                                'Case No: CR -2026-014',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 24),
                              Icon(Icons.access_time_outlined, color: Color(0xFFEF4444), size: 15),
                              SizedBox(width: 8),
                              Text(
                                '10:30AM  .  District Court',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 24),
                              Icon(Icons.person_outline, color: Color(0xFFEF4444), size: 15),
                              SizedBox(width: 8),
                              Text(
                                'Client : Ramesh Kumar',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFFEE2E2)),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.info_outline, color: Color(0xFFEF4444), size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Be prepared with documents before 9:30 AM.',
                                      style: TextStyle(
                                        color: Color(0xFFEF4444),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const APMSCaseDetailsScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.description_outlined, color: Colors.white, size: 14),
                                    SizedBox(width: 6),
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    ClipPath(
                      clipper: const HexagonClipper(),
                      child: Image.asset(
                        'assets/images/4.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Overview Header
              const Text(
                'Overview',
                style: TextStyle(
                  color: Color(0xFF0F1E36),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Horizontal Overview Row
              Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.work_outline,
                      color: const Color(0xFFEFF6FF),
                      iconColor: Colors.blue,
                      value: _activeCasesCount.toString(),
                      label: 'Active Cases',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const APMSCourtHearingsScreen()),
                        );
                      },
                      child: OverviewCard(
                        icon: Icons.gavel_outlined,
                        color: const Color(0xFFF5F3FF),
                        iconColor: Colors.purple,
                        value: _todayHearingsCount.toString(),
                        label: 'Today\'s Hearings',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const APMSPoliceVisitsScreen()),
                        );
                      },
                      child: OverviewCard(
                        icon: Icons.shield_outlined,
                        color: const Color(0xFFFFF7ED),
                        iconColor: Colors.orange,
                        value: _policeVisitsCount.toString(),
                        label: 'Police Visits',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.people_outline,
                      color: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      value: _clientMeetingsCount.toString(),
                      label: 'Client Meetings',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OverviewCard(
                      icon: Icons.currency_rupee,
                      color: const Color(0xFFFEF2F2),
                      iconColor: Colors.red,
                      value: _pendingPaymentsAmount,
                      label: 'Pending Payments',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const APMSRemindersScreen()),
                        );
                      },
                      child: OverviewCard(
                        icon: Icons.access_time,
                        color: const Color(0xFFFEFCE8),
                        iconColor: const Color(0xFFD97706),
                        value: _pendingTasksCount.toString(),
                        label: 'Pending Tasks',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Bottom Grid Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Card
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            color: Color(0xFF0F1E36),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  QuickActionButton(
                                    icon: Icons.person_add_alt_1_outlined,
                                    color: const Color(0xFFEFF6FF),
                                    iconColor: Colors.blue,
                                    label: 'Add Client',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const APMSAddClientScreen()),
                                      );
                                    },
                                  ),
                                  QuickActionButton(
                                    icon: Icons.work_outline,
                                    color: const Color(0xFFF5F3FF),
                                    iconColor: Colors.purple,
                                    label: 'Add Case',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const APMSAddCaseScreen()),
                                      );
                                    },
                                  ),
                                  QuickActionButton(
                                    icon: Icons.description_outlined,
                                    color: const Color(0xFFE0F2FE),
                                    iconColor: Colors.lightBlue,
                                    label: 'Documents',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const APMSEvidenceScreen()),
                                      );
                                    },
                                  ),
                                  QuickActionButton(
                                    icon: Icons.shield_outlined,
                                    color: const Color(0xFFFFF7ED),
                                    iconColor: Colors.orange,
                                    label: 'Police Visit',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const APMSPoliceVisitsScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  QuickActionButton(
                                    icon: Icons.event_note_outlined,
                                    color: const Color(0xFFFEE2E2),
                                    iconColor: Colors.red,
                                    label: 'Create Event',
                                  ),
                                  const SizedBox(width: 32),
                                  QuickActionButton(
                                    icon: Icons.cloud_upload_outlined,
                                    color: const Color(0xFFE0F2FE),
                                    iconColor: Colors.blue,
                                    label: 'Upload Doc',
                                  ),
                                  const SizedBox(width: 32),
                                  QuickActionButton(
                                    icon: Icons.notifications_none_outlined,
                                    color: const Color(0xFFE8F5E9),
                                    iconColor: Colors.green,
                                    label: 'Reminder',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const APMSRemindersScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Today's Schedule Card
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Today\'s Schedule',
                              style: TextStyle(
                                color: Color(0xFF0F1E36),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'View all',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._todaySchedule.map((item) {
                          return ScheduleItem(
                            time: item['time'] as String,
                            title: item['title'] as String,
                            subtitle: item['subtitle'] as String,
                            tag: item['tag'] as String,
                            color: item['color'] as Color,
                            tagBgColor: const Color(0xFFF3F4F6),
                            tagTextColor: const Color(0xFF4B5563),
                          );
                        }),
                      ],
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
}
