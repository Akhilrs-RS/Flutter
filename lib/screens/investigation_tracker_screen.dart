import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/police_visits_screen.dart';
import 'package:advocate_app/screens/fir_management_screen.dart';
import 'package:advocate_app/screens/evidence_screen.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';

class APMSInvestigationTrackerScreen extends StatefulWidget {
  const APMSInvestigationTrackerScreen({super.key});

  @override
  State<APMSInvestigationTrackerScreen> createState() => _APMSInvestigationTrackerScreenState();
}

class _APMSInvestigationTrackerScreenState extends State<APMSInvestigationTrackerScreen> {
  final List<Map<String, dynamic>> _timelineItems = const [
    {
      'title': 'Complaint Received',
      'date': 'Jan 08, 2026',
      'subtitle': 'Complaint lodged by Rajan Sharma',
      'status': 'completed',
    },
    {
      'title': 'FIR Registered',
      'date': 'Jan 10, 2026',
      'subtitle': 'FIR No. 2026/047 at Andheri PS',
      'status': 'completed',
    },
    {
      'title': 'Investigation Started',
      'date': 'Jan 12, 2026',
      'subtitle': 'IO Rajesh Patil assigned',
      'status': 'completed',
    },
    {
      'title': 'Witness Examination',
      'date': 'Feb 15, 2026',
      'subtitle': '3 witnesses recorded',
      'status': 'completed',
    },
    {
      'title': 'Evidence Collection',
      'date': 'Mar 01, 2026',
      'subtitle': 'CCTV footage, forensics secured',
      'status': 'completed',
    },
    {
      'title': 'Arrest',
      'date': 'Mar 20, 2026',
      'subtitle': 'Accused apprehended',
      'status': 'completed',
    },
    {
      'title': 'Bail Application',
      'date': 'Apr 02, 2026',
      'subtitle': 'Bail granted - conditions apply',
      'status': 'current',
    },
    {
      'title': 'Charge Sheet Filed',
      'date': 'Pending',
      'subtitle': '',
      'status': 'pending',
    },
    {
      'title': 'Final Report',
      'date': 'Pending',
      'subtitle': '',
      'status': 'pending',
    },
    {
      'title': 'Trial Started',
      'date': 'Pending',
      'subtitle': '',
      'status': 'pending',
    },
    {
      'title': 'Case Closed',
      'date': 'Pending',
      'subtitle': '',
      'status': 'pending',
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
                          'Investigation Tracker',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'CR-2026-047',
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
                      _buildTopTabs(context, 'Investigation'),
                      const SizedBox(height: 20),
                      _buildActionButtonsRow(),
                      const SizedBox(height: 24),
                      _buildTimelineList(),
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
              const Text(
                'Police Visits',
                style: TextStyle(
                  color: Color(0xFF0F1E36),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTopTabs(context, 'Investigation'),
              const SizedBox(height: 32),
              _buildActionButtonsRow(),
              const SizedBox(height: 32),
              _buildDesktopTimeline(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTimeline() {
    List<Widget> rows = [];
    for (int i = 0; i < _timelineItems.length; i += 3) {
      int end = (i + 3 < _timelineItems.length) ? i + 3 : _timelineItems.length;
      List<Map<String, dynamic>> sublist = _timelineItems.sublist(i, end);
      rows.add(_buildDesktopTimelineRow(sublist));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _buildDesktopTimelineRow(List<Map<String, dynamic>> items) {
    List<Widget> children = [];
    for (int i = 0; i < items.length; i++) {
      children.add(
        Expanded(
          child: _buildDesktopTimelineItem(items[i]),
        ),
      );
      if (i < items.length - 1) {
        children.add(const SizedBox(width: 8));
        children.add(
          Container(
            width: 48,
            height: 1.5,
            color: items[i]['status'] == 'completed' ? Colors.black : const Color(0xFFD1D5DB),
          ),
        );
        children.add(const SizedBox(width: 8));
      }
    }
    while (children.length < 5) {
      children.add(const SizedBox(width: 8));
      children.add(const Expanded(child: SizedBox.shrink()));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildDesktopTimelineItem(Map<String, dynamic> item) {
    final title = item['title'] as String;
    final date = item['date'] as String;
    final subtitle = item['subtitle'] as String;
    final status = item['status'] as String;

    Widget dot;
    if (status == 'completed') {
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      );
    } else if (status == 'current') {
      dot = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange, width: 6.0),
        ),
      );
    } else {
      dot = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD1D5DB), width: 2.0),
        ),
      );
    }

    final isPending = status == 'pending';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dot,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isPending ? const Color(0xFF9CA3AF) : const Color(0xFF0F1E36),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (date.isNotEmpty && date != 'Pending')
                Text(
                  date,
                  style: TextStyle(
                    color: isPending ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
                    fontSize: 11,
                  ),
                ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isPending ? const Color(0xFFD1D5DB) : const Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: Row(
              children: const [
                Icon(Icons.add, size: 16),
                SizedBox(width: 6),
                Text('Add Activity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: Row(
              children: const [
                Icon(Icons.cloud_upload_outlined, color: Color(0xFF374151), size: 16),
                SizedBox(width: 6),
                Text('Upload Evidence', style: TextStyle(color: Color(0xFF374151), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today_outlined, color: Color(0xFF374151), size: 16),
                SizedBox(width: 6),
                Text('Schedule Follow-up', style: TextStyle(color: Color(0xFF374151), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(_timelineItems.length, (index) {
          final item = _timelineItems[index];
          final title = item['title'] as String;
          final date = item['date'] as String;
          final subtitle = item['subtitle'] as String;
          final status = item['status'] as String;

          Color indicatorColor;
          Widget dot;
          if (status == 'completed') {
            indicatorColor = Colors.black;
            dot = Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            );
          } else if (status == 'current') {
            indicatorColor = Colors.orange;
            dot = Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: const [
                  BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
            );
          } else {
            indicatorColor = const Color(0xFF9CA3AF);
            dot = Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1D5DB), width: 2.0),
              ),
            );
          }

          final isLast = index == _timelineItems.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline Line column
                Column(
                  children: [
                    const SizedBox(height: 6),
                    dot,
                    if (!isLast)
                      Expanded(
                        child: CustomPaint(
                          painter: LinePainter(
                            color: indicatorColor,
                            isDashed: status == 'pending',
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Card details column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: const Color(0xFF0F1E36),
                                fontSize: 14,
                                fontWeight: status == 'current' ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                            if (date.isNotEmpty && date != 'Pending')
                              Text(
                                date,
                                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                              ),
                          ],
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  LinePainter({required this.color, required this.isDashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double startY = 6.0;
    final double endY = size.height;

    if (isDashed) {
      double dashHeight = 4.0;
      double dashSpace = 4.0;
      double currentY = startY;

      while (currentY < endY) {
        canvas.drawLine(
          Offset(size.width / 2, currentY),
          Offset(size.width / 2, currentY + dashHeight),
          paint,
        );
        currentY += dashHeight + dashSpace;
      }
    } else {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
