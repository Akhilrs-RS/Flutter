import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/case_details_screen.dart';
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
  String _selectedFilter = 'Today';
  List<Map<String, dynamic>> _allHearings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHearings();
  }

  void _fetchHearings() async {
    final data = await ApiService.getHearings();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (data.isNotEmpty) {
          _allHearings = data;
        } else {
          _allHearings = List<Map<String, dynamic>>.from(_mockHearings);
        }
      });
    }
  }

  void _showAddHearingDialog(BuildContext context) {
    final caseNoController = TextEditingController();
    final clientController = TextEditingController();
    final courtController = TextEditingController();
    final judgeController = TextEditingController();
    final timeController = TextEditingController();

    String type = 'Today';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Add Hearing', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: caseNoController,
                      decoration: const InputDecoration(labelText: 'Case Number', hintText: 'e.g. CR-2026-047'),
                    ),
                    TextField(
                      controller: clientController,
                      decoration: const InputDecoration(labelText: 'Client Name', hintText: 'e.g. Rajan Sharma'),
                    ),
                    TextField(
                      controller: courtController,
                      decoration: const InputDecoration(labelText: 'Court Name / Hall', hintText: 'e.g. Hall 7, Bombay HC'),
                    ),
                    TextField(
                      controller: judgeController,
                      decoration: const InputDecoration(labelText: 'Honorable Judge', hintText: 'e.g. Judge Elena Vance'),
                    ),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(labelText: 'Time / Date', hintText: 'e.g. 10:30 AM or Jul 22, 11 AM'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      items: const [
                        DropdownMenuItem(value: 'Today', child: Text('Today')),
                        DropdownMenuItem(value: 'Upcoming', child: Text('Upcoming')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => type = val);
                      },
                      decoration: const InputDecoration(labelText: 'Schedule'),
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
                    final caseNo = caseNoController.text.trim();
                    final client = clientController.text.trim();
                    final court = courtController.text.trim();
                    final judge = judgeController.text.trim();
                    final time = timeController.text.trim();

                    if (caseNo.isEmpty || client.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Case number and Client Name are required.')),
                      );
                      return;
                    }

                    final newHearing = {
                      'caseNo': caseNo,
                      'client': client,
                      'tag': type,
                      'court': court.isEmpty ? 'High Court - Hall 1' : court,
                      'judge': judge.isEmpty ? 'Judge Elena Vance' : judge,
                      'time': time.isEmpty ? '10:30 AM' : time,
                      'isCompleted': false,
                      'isToday': type == 'Today',
                      'isUpcoming': type == 'Upcoming',
                    };

                    final success = await ApiService.addHearing(newHearing);
                    if (success) {
                      _fetchHearings();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hearing added successfully.')),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save hearing to server.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  child: const Text('Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showUpdateOutcomeDialog(BuildContext context, String caseNo) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Update Outcome', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Outcome Notes',
              hintText: 'e.g. Cross-examination deferred till next date.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final note = noteController.text.trim();
                final success = await ApiService.updateHearing(caseNo, {
                  'isCompleted': true,
                  'isToday': false,
                  'isUpcoming': false,
                  'note': note.isEmpty ? 'Completed successfully' : note,
                });
                if (success) {
                  _fetchHearings();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Outcome updated successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update outcome on server.')),
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

  void _showAddOrderDialog(BuildContext context, String caseNo) {
    final orderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Order details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: orderController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Order details / file reference',
              hintText: 'e.g. Interim injunction granted. Order copy uploaded.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final orderText = orderController.text.trim();
                final success = await ApiService.updateHearing(caseNo, {
                  'order': orderText.isEmpty ? 'Order details attached' : orderText,
                });
                if (success) {
                  _fetchHearings();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order details attached successfully.')),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to attach order details.')),
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

  void _navigateToCaseDetails(BuildContext context, String caseNo) async {
    final cases = await ApiService.getCases();
    Map<String, dynamic>? matchedCase;
    for (var c in cases) {
      if (c['caseNo']?.toString().toLowerCase().trim() == caseNo.toLowerCase().trim()) {
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
    final todayCount = _allHearings.where((h) => h['isToday'] == true && h['isCompleted'] != true).length;
    final todayFilterText = 'Today ($todayCount)';
    final dynamicFilters = [todayFilterText, 'Upcoming', 'Completed'];

    final filteredHearings = _allHearings.where((h) {
      if (_selectedFilter.startsWith('Today')) return h['isToday'] == true && h['isCompleted'] != true;
      if (_selectedFilter == 'Upcoming') return h['isUpcoming'] == true && h['isCompleted'] != true;
      if (_selectedFilter == 'Completed') return h['isCompleted'] == true;
      return true;
    }).toList();

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
                        onTap: () => _showAddHearingDialog(context),
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
                      children: const [
                        Text(
                          'Schedule Hearings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Track court schedules and update outcomes',
                          style: TextStyle(
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
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: dynamicFilters.map((filter) {
                          final isSelected = (_selectedFilter.startsWith('Today') && filter.startsWith('Today')) || (_selectedFilter == filter);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CaseFilterTab(
                                label: filter,
                                selected: isSelected,
                              ),
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
              icon: const Icon(Icons.gavel_rounded, color: Colors.black, size: 26),
              onPressed: () {},
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
    final todayCount = _allHearings.where((h) => h['isToday'] == true && h['isCompleted'] != true).length;
    final todayFilterText = 'Today ($todayCount)';
    final dynamicFilters = [todayFilterText, 'Upcoming', 'Completed'];

    final filteredHearings = _allHearings.where((h) {
      if (_selectedFilter.startsWith('Today')) return h['isToday'] == true && h['isCompleted'] != true;
      if (_selectedFilter == 'Upcoming') return h['isUpcoming'] == true && h['isCompleted'] != true;
      if (_selectedFilter == 'Completed') return h['isCompleted'] == true;
      return true;
    }).toList();

    List<Widget> leftCol = [];
    List<Widget> rightCol = [];
    for (int i = 0; i < filteredHearings.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(_buildHearingCard(filteredHearings[i]));
      } else {
        rightCol.add(_buildHearingCard(filteredHearings[i]));
      }
    }

    return DesktopLayoutWrapper(
      activeMenu: 'Hearings',
      child: Theme(
        data: ThemeData(brightness: Brightness.light),
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
                    onPressed: () => _showAddHearingDialog(context),
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
                children: dynamicFilters.map((filter) {
                  final isSelected = (_selectedFilter.startsWith('Today') && filter.startsWith('Today')) || (_selectedFilter == filter);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CaseFilterTab(
                        label: filter,
                        selected: isSelected,
                      ),
                    ),
                  );
                }).toList(),
              ),
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

  Widget _buildHearingCard(Map<String, dynamic> h) {
    final caseNo = h['caseNo']?.toString() ?? '';
    final client = (h['client'] ?? h['title'] ?? 'N/A').toString();
    final tag = (h['tag'] ?? h['tag2'] ?? 'Hearing').toString();
    final court = h['court']?.toString() ?? 'N/A';
    final judge = h['judge']?.toString() ?? 'Judge Elena Vance';
    final time = h['time'] != null && h['period'] != null
        ? '${h['time']} ${h['period']}'
        : (h['time']?.toString() ?? 'N/A');
    final isCompleted = h['isCompleted'] as bool? ?? false;
    final note = h['note']?.toString();
    final order = h['order']?.toString();

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
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagBgColor,
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
                const SizedBox(height: 8),
                Text(
                  client,
                  style: const TextStyle(
                    color: Color(0xFF0F1E36),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.gavel_outlined, color: Color(0xFF9CA3AF), size: 14),
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
                    const Icon(Icons.person_outline, color: Color(0xFF9CA3AF), size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        judge,
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
                          onPressed: () => _showUpdateOutcomeDialog(context, caseNo),
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
                          onPressed: () => _showAddOrderDialog(context, caseNo),
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
                          onPressed: () => _navigateToCaseDetails(context, caseNo),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                'Outcome: $note',
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (order != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                'Order Details: $order',
                style: const TextStyle(
                  color: Color(0xFF1E40AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
