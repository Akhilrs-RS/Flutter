import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSCourtHearingsScreen extends StatefulWidget {
  const APMSCourtHearingsScreen({super.key});

  @override
  State<APMSCourtHearingsScreen> createState() => _APMSCourtHearingsScreenState();
}

class _APMSCourtHearingsScreenState extends State<APMSCourtHearingsScreen> {
  String _selectedFilter = 'Today (2)';

  final List<String> _filters = ['Today (2)', 'Upcoming', 'Completed'];

  List<Map<String, dynamic>> _allHearings = [];

  @override
  void initState() {
    super.initState();
    _fetchHearings();
  }

  void _fetchHearings() async {
    final data = await ApiService.getHearings();
    if (data.isNotEmpty) {
      if (mounted) {
        setState(() {
          _allHearings = data;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _allHearings = List<Map<String, dynamic>>.from(_mockHearings);
        });
      }
    }
  }

  final List<Map<String, dynamic>> _mockHearings = const [
    {
      'caseNo': 'CR-2026-012',
      'client': 'Priya Mehta',
      'tag': 'Today',
      'court': 'City Civil - Hall 2',
      'time': '02:00 PM',
      'isCompleted': false,
      'isToday': true,
      'isUpcoming': false,
    },
    {
      'caseNo': 'CR-2026-047',
      'client': 'Rajan Sharma',
      'tag': 'Today',
      'court': 'Bombay HC - Hall 7',
      'time': '10:30 AM',
      'isCompleted': false,
      'isToday': true,
      'isUpcoming': false,
    },
    {
      'caseNo': 'CR-2026-003',
      'client': 'Sunita Rao',
      'tag': 'Upcoming',
      'court': 'Family Court - Hall 1',
      'time': 'Jul 18, 10 AM',
      'isCompleted': false,
      'isToday': false,
      'isUpcoming': true,
    },
    {
      'caseNo': 'MV-2025-089',
      'client': 'Arjun Patel',
      'tag': 'Upcoming',
      'court': 'Sessions - Hall 5',
      'time': 'Jul 22, 11 AM',
      'isCompleted': false,
      'isToday': false,
      'isUpcoming': true,
    },
    {
      'caseNo': 'CR-2025-099',
      'client': 'Vikram Das',
      'tag': 'Completed',
      'court': 'High Court - Hall 3',
      'time': 'Jul 02, 03:00 PM',
      'isCompleted': true,
      'isToday': false,
      'isUpcoming': false,
      'note': 'Hearing completed successfully',
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
    final filteredHearings = _allHearings.where((h) {
      if (_selectedFilter == 'Today (2)') return h['isToday'] as bool;
      if (_selectedFilter == 'Upcoming') return h['isUpcoming'] as bool;
      if (_selectedFilter == 'Completed') return h['isCompleted'] as bool;
      return true;
    }).toList();

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
                      Container(
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Count Hearings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '8 hearings this week',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
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
                              hintText: 'Search by Case # or Title',
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
            // Content
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      // Filters Row
                      Row(
                        children: _filters.map((filter) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: CaseFilterTab(
                              label: filter,
                              selected: _selectedFilter == filter,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      ...filteredHearings.map((h) {
                        return _buildHearingCard(h);
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
              icon: const Icon(Icons.grid_view_rounded, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(Icons.gavel_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const APMSCasesScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const APMSCalendarScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const APMSNotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).pushReplacement(
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
    final filteredHearings = _allHearings.where((h) {
      if (_selectedFilter == 'Today (2)') return h['isToday'] as bool;
      if (_selectedFilter == 'Upcoming') return h['isUpcoming'] as bool;
      if (_selectedFilter == 'Completed') return h['isCompleted'] as bool;
      return true;
    }).toList();

    return DesktopLayoutWrapper(
      activeMenu: 'Hearings',
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
                    'Court Hearings',
                    style: TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                      '+ Add Hearing',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: _filters.map((filter) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: CaseFilterTab(
                      label: filter,
                      selected: _selectedFilter == filter,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              _buildDesktopHearingsGrid(filteredHearings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHearingsGrid(List<Map<String, dynamic>> hearings) {
    List<Widget> leftCol = [];
    List<Widget> rightCol = [];
    for (int i = 0; i < hearings.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(_buildHearingCard(hearings[i]));
      } else {
        rightCol.add(_buildHearingCard(hearings[i]));
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

  Widget _buildHearingCard(Map<String, dynamic> h) {
    final caseNo = h['caseNo']?.toString() ?? '';
    final client = (h['client'] ?? h['title'] ?? 'N/A').toString();
    final tag = (h['tag'] ?? h['tag2'] ?? 'Hearing').toString();
    final court = h['court']?.toString() ?? 'N/A';
    final time = h['time'] != null && h['period'] != null
        ? '${h['time']} ${h['period']}'
        : (h['time']?.toString() ?? 'N/A');
    final isCompleted = h['isCompleted'] as bool? ?? false;
    final note = h['note']?.toString();

    Color tagBgColor;
    Color tagTextColor;
    if (tag == 'Today' || tag == 'Completed') {
      tagBgColor = const Color(0xFFDCFCE7);
      tagTextColor = const Color(0xFF15803D);
    } else {
      tagBgColor = const Color(0xFFDBEAFE);
      tagTextColor = const Color(0xFF1D4ED8);
    }

    final isToday = tag == 'Today';
    final timeIcon = isToday ? Icons.access_time_outlined : Icons.calendar_month_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        caseNo,
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: tagBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  const SizedBox(height: 8),
                  Text(
                    client,
                    style: const TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFF9CA3AF), size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          court,
                          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(timeIcon, color: const Color(0xFF9CA3AF), size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          time,
                          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Update Outcome',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              foregroundColor: const Color(0xFF374151),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Add Order',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              foregroundColor: const Color(0xFF374151),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Navigate',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (isCompleted && note != null)
              Container(
                width: double.infinity,
                color: const Color(0xFFECFDF5),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      note,
                      style: const TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
