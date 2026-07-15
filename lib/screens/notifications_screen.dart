import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSNotificationsScreen extends StatefulWidget {
  const APMSNotificationsScreen({super.key});

  @override
  State<APMSNotificationsScreen> createState() => _APMSNotificationsScreenState();
}

class _APMSNotificationsScreenState extends State<APMSNotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Hearings', 'Police', 'Payments', 'Due'];

  List<NotificationItem> _allNotifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    final data = await ApiService.getNotifications();
    if (data.isNotEmpty) {
      if (mounted) {
        setState(() {
          _allNotifications = data.map((json) => _parseNotification(json)).toList();
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _allNotifications = List<NotificationItem>.from(_mockNotifications);
        });
      }
    }
  }

  NotificationItem _parseNotification(Map<String, dynamic> json) {
    IconData iconData = Icons.notifications_none;
    switch (json['icon'] as String?) {
      case 'gavel':
        iconData = Icons.gavel;
        break;
      case 'shield':
        iconData = Icons.shield_outlined;
        break;
      case 'currency_rupee':
        iconData = Icons.currency_rupee;
        break;
      case 'description':
        iconData = Icons.description_outlined;
        break;
      case 'person':
        iconData = Icons.person_outline;
        break;
    }

    return NotificationItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      time: json['time'] as String,
      type: json['type'] as String,
      isUnread: json['isUnread'] as bool,
      icon: iconData,
      iconBgColor: Color(int.parse(json['iconBgColor'] as String)),
      iconColor: Color(int.parse(json['iconColor'] as String)),
    );
  }

  final List<NotificationItem> _mockNotifications = const [
    NotificationItem(
      title: 'Hearing Reminder',
      subtitle: 'CR-2026-047 hearing tomorrow at 10:30 AM – Bombay HC Hall 7',
      time: '5m ago',
      type: 'Hearings',
      isUnread: true,
      icon: Icons.gavel,
      iconBgColor: Color(0xFFF3E8FF),
      iconColor: Color(0xFF9333EA),
    ),
    NotificationItem(
      title: 'Police Visit Due',
      subtitle: 'Scheduled visit to Andheri PS today at 2:00 PM',
      time: '12m ago',
      type: 'Police',
      isUnread: true,
      icon: Icons.shield_outlined,
      iconBgColor: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
    ),
    NotificationItem(
      title: 'Payment Received',
      subtitle: '₹15,000 received from Priya Mehta for Case CIV-2026-012',
      time: '1h ago',
      type: 'Payments',
      isUnread: true,
      icon: Icons.currency_rupee,
      iconBgColor: Color(0xFFD1FAE5),
      iconColor: Color(0xFF059669),
    ),
    NotificationItem(
      title: 'Document Uploaded',
      subtitle: 'FIR copy for Case CR-2026-047 has been uploaded',
      time: '2h ago',
      type: 'Docs',
      isUnread: false,
      icon: Icons.description_outlined,
      iconBgColor: Color(0xFFDBEAFE),
      iconColor: Color(0xFF2563EB),
    ),
    NotificationItem(
      title: 'Reminder: File Bail',
      subtitle: 'Bail application for Ajay Sharma due in 2 days',
      time: '3h ago',
      type: 'Reminder',
      isUnread: false,
      icon: Icons.notifications_none,
      iconBgColor: Color(0xFFFEE2E2),
      iconColor: Color(0xFFDC2626),
    ),
    NotificationItem(
      title: 'New Client Added',
      subtitle: 'Vikram Das has been added as a new client',
      time: '5h ago',
      type: 'Client',
      isUnread: false,
      icon: Icons.person_outline,
      iconBgColor: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildMobileLayout(context),
      desktopLayout: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final filteredNotifications = _allNotifications.where((n) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Due') {
        return n.type == 'Docs' || n.type == 'Reminder';
      }
      return n.type == _selectedFilter;
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_allNotifications.where((n) => n.isUnread).length} Unread',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      ...filteredNotifications.map((n) => NotificationListItemCard(item: n)),
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const APMSCalendarScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black, size: 26),
              onPressed: () {},
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
    final filteredNotifications = _allNotifications.where((n) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Due') {
        return n.type == 'Docs' || n.type == 'Reminder';
      }
      return n.type == _selectedFilter;
    }).toList();

    return DesktopLayoutWrapper(
      activeMenu: 'Notifications',
      searchHintText: 'Search for hearings...',
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
              ...filteredNotifications.map((n) => NotificationListItemCard(item: n)),
            ],
          ),
        ),
      ),
    );
  }
}
