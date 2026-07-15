import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/case_details_screen.dart';
import 'package:advocate_app/screens/add_case_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSCasesScreen extends StatefulWidget {
  const APMSCasesScreen({super.key});

  @override
  State<APMSCasesScreen> createState() => _APMSCasesScreenState();
}

class _APMSCasesScreenState extends State<APMSCasesScreen> {
  String _selectedFilter = 'Active';

  final List<String> _filters = ['Active', 'Hearing Today', 'Pending', 'Appealed', 'Closed'];

  List<Map<String, dynamic>> _allCases = [];

  @override
  void initState() {
    super.initState();
    _fetchCases();
  }

  void _fetchCases() async {
    final data = await ApiService.getCases();
    if (data.isNotEmpty) {
      if (mounted) {
        setState(() {
          _allCases = data;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _allCases = List<Map<String, dynamic>>.from(_mockCases);
        });
      }
    }
  }

  final List<Map<String, dynamic>> _mockCases = const [
    {
      'caseNo': 'CR-2024-8842-DL',
      'title': 'State vs. Harrison Miller',
      'court': 'Delhi High Court - Room 4B',
      'nextDate': 'Next: Oct 24, 2026',
      'clientName': 'Harrison Miller',
      'clientPhoto': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=120',
      'status': 'Active',
      'statusBgColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'leftStripColor': Color(0xFF10B981),
      'isHearingToday': false,
      'isPending': false,
      'isAppealed': false,
    },
    {
      'caseNo': 'CR-2026-047',
      'title': 'State vs. Rajan Sharma',
      'court': 'Bombay High Court',
      'nextDate': 'Next: Jan 10, 2026',
      'nextDateToday': 'Next: Today',
      'clientName': 'Rajan Sharma',
      'clientPhoto': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=80',
      'status': 'Active',
      'statusBgColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'leftStripColor': Color(0xFF10B981),
      'isHearingToday': true,
      'isPending': false,
      'isAppealed': false,
    },
    {
      'caseNo': 'CIV-2026-012',
      'title': 'Mehta vs. Global Dynamics',
      'court': 'Delhi High Court',
      'nextDate': 'Next: Feb 15, 2026',
      'clientName': 'Priya Mehta',
      'clientPhoto': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=80',
      'status': 'Pending',
      'statusBgColor': Color(0xFFFEF3C7),
      'statusTextColor': Color(0xFFD97706),
      'leftStripColor': Colors.orange,
      'isHearingToday': false,
      'isPending': true,
      'isAppealed': false,
    },
    {
      'caseNo': 'CIV-2026-003',
      'title': 'Rao vs. Sterling Ltd',
      'court': 'Bombay High Court',
      'nextDate': 'Next: Jul 18, 2026',
      'clientName': 'Sunita Rao',
      'clientPhoto': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=80',
      'status': 'Appealed',
      'statusBgColor': Color(0xFFF3E8FF),
      'statusTextColor': Color(0xFF7C3AED),
      'leftStripColor': Color(0xFF7C3AED),
      'isHearingToday': false,
      'isPending': false,
      'isAppealed': true,
    },
  ];

  List<Map<String, dynamic>> _getFilteredCases() {
    switch (_selectedFilter) {
      case 'Active':
        return _allCases;
      case 'Hearing Today':
        return _allCases.where((c) => c['isHearingToday'] as bool).toList();
      case 'Pending':
        return _allCases.where((c) => c['isPending'] as bool).toList();
      case 'Appealed':
        return _allCases.where((c) => c['isAppealed'] as bool).toList();
      default:
        return [];
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                color: Color(0xFF9CA3AF),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Cases Found',
              style: TextStyle(
                color: Color(0xFF0F1E36),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStarsCard() {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.star_outline, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Total Active Docket',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '14 active cases',
                  style: TextStyle(
                    color: Color(0xFF0F1E36),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCasesSummaryCard() {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.folder_open_outlined, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Total Cases',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '64 total cases',
                  style: TextStyle(
                    color: Color(0xFF0F1E36),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCardItem(BuildContext context, Map<String, dynamic> c) {
    final status = c['status'] as String;
    final isHearingTodayFilter = _selectedFilter == 'Hearing Today';
    final displayNextDate = isHearingTodayFilter && c.containsKey('nextDateToday')
        ? c['nextDateToday'] as String
        : c['nextDate'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: c['leftStripColor'] as Color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c['caseNo'] as String,
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: c['statusBgColor'] as Color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: c['statusTextColor'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c['title'] as String,
                        style: const TextStyle(
                          color: Color(0xFF0F1E36),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.gavel_outlined, color: Colors.grey, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              c['court'] as String,
                              style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              displayNextDate,
                              style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE5E7EB), height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(c['clientPhoto'] as String),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                c['clientName'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const APMSCaseDetailsScreen()),
                              );
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 10),
                              ],
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
    final filteredCases = _getFilteredCases();

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
                      const Text(
                        'Cases',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const APMSAddCaseScreen()),
                          ).then((_) => _fetchCases());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.add, color: Colors.black, size: 20),
                        ),
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
                              hintText: 'Search by Case # or Title',
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
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
                      ),
                      const SizedBox(height: 24),
                      if (filteredCases.isEmpty)
                        _buildEmptyState()
                      else
                        Column(
                          children: [
                            ...filteredCases.map((c) => _buildCaseCardItem(context, c)),
                            const SizedBox(height: 8),
                            _buildSummaryStarsCard(),
                            const SizedBox(height: 8),
                          ],
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
              icon: const Icon(Icons.gavel_outlined, color: Colors.black, size: 26),
              onPressed: () {},
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
    final filteredCases = _getFilteredCases();

    return DesktopLayoutWrapper(
      activeMenu: 'Cases',
      child: Theme(
        data: ThemeData(
          brightness: Brightness.light,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 24) / 2;
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters Tab Row
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
                  // Grid List
                  if (filteredCases.isEmpty)
                    _buildEmptyState()
                  else
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: filteredCases.map((c) {
                        return SizedBox(
                          width: cardWidth,
                          child: _buildCaseCardItem(context, c),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 32),
                  // Summary Statistics
                  if (_selectedFilter == 'Active')
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryStarsCard(),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTotalCasesSummaryCard(),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
