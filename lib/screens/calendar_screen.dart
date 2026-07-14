import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';

class APMSCalendarScreen extends StatefulWidget {
  const APMSCalendarScreen({super.key});

  @override
  State<APMSCalendarScreen> createState() => _APMSCalendarScreenState();
}

class _APMSCalendarScreenState extends State<APMSCalendarScreen> {
  String _currentView = 'Week';

  final List<Map<String, dynamic>> _monthDays = const [
    {'day': null, 'dots': <Color>[]},
    {'day': null, 'dots': <Color>[]},
    {'day': null, 'dots': <Color>[]},
    {'day': null, 'dots': <Color>[]},
    {'day': null, 'dots': <Color>[]},
    {'day': 1, 'dots': <Color>[]},
    {'day': 2, 'dots': <Color>[]},
    {'day': 3, 'dots': <Color>[]},
    {'day': 4, 'dots': <Color>[]},
    {'day': 5, 'dots': <Color>[]},
    {'day': 6, 'dots': <Color>[]},
    {'day': 7, 'dots': <Color>[]},
    {'day': 8, 'dots': <Color>[]},
    {'day': 9, 'dots': <Color>[]},
    {'day': 10, 'dots': <Color>[]},
    {'day': 11, 'dots': <Color>[]},
    {'day': 12, 'dots': [Colors.green]},
    {'day': 13, 'dots': [Colors.blue, Colors.purple]},
    {'day': 14, 'dots': <Color>[]},
    {'day': 15, 'dots': [Colors.orange, Colors.blue]},
    {'day': 16, 'dots': <Color>[]},
    {'day': 17, 'dots': <Color>[]},
    {'day': 18, 'dots': [Colors.red]},
    {'day': 19, 'dots': <Color>[]},
    {'day': 20, 'dots': <Color>[]},
    {'day': 21, 'dots': <Color>[]},
    {'day': 22, 'dots': [Colors.blue]},
    {'day': 23, 'dots': <Color>[]},
    {'day': 24, 'dots': <Color>[]},
    {'day': 25, 'dots': [Colors.yellow, Colors.green]},
    {'day': 26, 'dots': <Color>[]},
    {'day': 27, 'dots': <Color>[]},
    {'day': 28, 'dots': <Color>[]},
    {'day': 29, 'dots': <Color>[]},
    {'day': 30, 'dots': <Color>[]},
    {'day': 31, 'dots': <Color>[]},
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
                      if (_currentView == 'Week')
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            '+ New Hearing',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
                      children: const [
                        Text(
                          'Court Hearings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sep 13',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      if (_currentView == 'Week') ...[
                        _buildWeekCalendarCard(),
                        const SizedBox(height: 24),
                        _buildWeekHearingsList(),
                      ] else ...[
                        _buildMonthSelectorRow(),
                        const SizedBox(height: 20),
                        _buildMonthCalendarCard(),
                        const SizedBox(height: 24),
                        _buildMonthEventsList(),
                      ],
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
              icon: const Icon(Icons.calendar_month_outlined, color: Colors.black, size: 26),
              onPressed: () {},
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
    return DesktopLayoutWrapper(
      activeMenu: 'Calendar',
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
                  if (_currentView == 'Week')
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text(
                        '+ New Hearing',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (_currentView == 'Week') ...[
                _buildWeekCalendarCard(),
                const SizedBox(height: 24),
                _buildWeekHearingsList(),
              ] else ...[
                _buildMonthSelectorRow(),
                const SizedBox(height: 20),
                _buildMonthCalendarCard(),
                const SizedBox(height: 24),
                _buildMonthEventsList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'September 2023',
                    style: TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_left, color: Color(0xFF6B7280), size: 20),
                  Icon(Icons.keyboard_arrow_right, color: Color(0xFF6B7280), size: 20),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentView = 'Month';
                  });
                },
                child: Row(
                  children: const [
                    Text(
                      'View more',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeekDayItem('Mon', '11', false),
              _buildWeekDayItem('Tue', '12', false),
              _buildWeekDayItem('Wed', '13', true),
              _buildWeekDayItem('Thu', '14', false),
              _buildWeekDayItem('Fri', '15', false),
              _buildWeekDayItem('Sat', '16', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayItem(String label, String dayNum, bool selected) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1E3A8A) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            dayNum,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF0F1E36),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekHearingsList() {
    return Column(
      children: [
        _buildHearingDetailCard(
          time: '10:30',
          period: 'AM',
          caseNo: 'Case #2934-22',
          title: 'Smith vs. Global Dynamics',
          court: 'Supreme Court, Room 402',
          judge: 'Hon. Justice Elena Rodriguez',
          tag1: 'Cross Examination',
          tag1Bg: const Color(0xFFEFF6FF),
          tag1Text: const Color(0xFF2563EB),
          tag2: 'Confirmed',
          tag2Bg: const Color(0xFFD1FAE5),
          tag2Text: const Color(0xFF059669),
          accentColor: const Color(0xFF10B981),
          showMarkDone: true,
        ),
        _buildHearingDetailCard(
          time: '02:15',
          period: 'PM',
          caseNo: 'Case #8120-23',
          title: 'State vs. Marcus Vane',
          court: 'District Court, Hall B',
          judge: 'Judge Theodore Wright',
          tag1: 'Final Arguments',
          tag1Bg: const Color(0xFFF5F3FF),
          tag1Text: const Color(0xFF7C3AED),
          tag2: 'Pending',
          tag2Bg: const Color(0xFFFEF3C7),
          tag2Text: const Color(0xFFD97706),
          accentColor: Colors.orange,
          showMarkDone: true,
        ),
        _buildHearingDetailCard(
          time: '04:45',
          period: 'PM',
          caseNo: 'Case #5541-21',
          title: 'Riverside HOA vs. Park',
          court: 'Civil Court, Room 12',
          judge: 'Judge Sarah Miller',
          tag1: 'Status Call',
          tag1Bg: const Color(0xFFEFF6FF),
          tag1Text: const Color(0xFF3B82F6),
          tag2: 'Adjourned',
          tag2Bg: const Color(0xFFF3F4F6),
          tag2Text: const Color(0xFF6B7280),
          accentColor: const Color(0xFF9CA3AF),
          showMarkDone: false,
        ),
      ],
    );
  }

  Widget _buildHearingDetailCard({
    required String time,
    required String period,
    required String caseNo,
    required String title,
    required String court,
    required String judge,
    required String tag1,
    required Color tag1Bg,
    required Color tag1Text,
    required String tag2,
    required Color tag2Bg,
    required Color tag2Text,
    required Color accentColor,
    required bool showMarkDone,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                color: Color(0xFF0F1E36),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              period,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                caseNo,
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Color(0xFF0F1E36),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.gavel_outlined, color: Colors.grey, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          court,
                          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.grey, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          judge,
                          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: tag1Bg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            tag1,
                            style: TextStyle(
                              color: tag1Text,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: tag2Bg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: tag2Text,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tag2,
                                style: TextStyle(
                                  color: tag2Text,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              'Reschedule',
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (showMarkDone) ...[
                          const SizedBox(width: 8),
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
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Mark Done',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
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
                                Icon(Icons.note_add_outlined, color: Color(0xFF374151), size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Add Order',
                                  style: TextStyle(
                                    color: Color(0xFF374151),
                                    fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelectorRow() {
    return Row(
      children: [
        _buildMonthViewTab('Day', false),
        _buildMonthViewTab('Week', false, onTap: () {
          setState(() {
            _currentView = 'Week';
          });
        }),
        _buildMonthViewTab('Month', true),
        _buildMonthViewTab('Agenda', false),
      ],
    );
  }

  Widget _buildMonthViewTab(String label, bool active, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? Colors.black : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black : const Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left, color: Color(0xFF6B7280), size: 24),
                onPressed: () {
                  setState(() {
                    _currentView = 'Week';
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'September 2023',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0F1E36),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, color: Color(0xFF6B7280), size: 24),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('Sun', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Mon', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Tue', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Wed', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Thu', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Fri', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              Text('Sat', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            itemCount: _monthDays.length,
            itemBuilder: (context, index) {
              final dayMap = _monthDays[index];
              final day = dayMap['day'] as int?;
              final List<Color> dots = dayMap['dots'] as List<Color>;

              if (day == null) return const SizedBox.shrink();

              final isSelected = day == 13;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF0F1E36),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dots.map((color) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    )).toList(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Hearings', Colors.blue),
                const SizedBox(width: 8),
                _buildLegendItem('Police', Colors.orange),
                const SizedBox(width: 8),
                _buildLegendItem('Meetings', Colors.green),
                const SizedBox(width: 8),
                _buildLegendItem('Urgent', Colors.red),
                const SizedBox(width: 8),
                _buildLegendItem('Consultations', const Color(0xFF1E3A8A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthEventsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'TODAY\'S EVENTS',
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          ),
          child: Column(
            children: [
              _buildMonthEventRow(
                time: '10:30',
                title: 'Sharma vs State',
                subtitle: 'Bombay HC – Hall 7',
                accentColor: Colors.blue,
                showDivider: true,
              ),
              _buildMonthEventRow(
                time: '14:00',
                title: 'Police Visit – Andheri PS',
                subtitle: 'IO Rajesh Patil',
                accentColor: Colors.orange,
                showDivider: true,
              ),
              _buildMonthEventRow(
                time: '16:30',
                title: 'Client Meeting – Mehta',
                subtitle: 'Office consultation',
                accentColor: Colors.green,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthEventRow({
    required String time,
    required String title,
    required String subtitle,
    required Color accentColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF0F1E36),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Container(width: 3, height: 28, color: accentColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F1E36),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(color: Color(0xFFE5E7EB), height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
