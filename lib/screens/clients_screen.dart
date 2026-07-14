import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/add_client_screen.dart';

class APMSClientsScreen extends StatefulWidget {
  const APMSClientsScreen({super.key});

  @override
  State<APMSClientsScreen> createState() => _APMSClientsScreenState();
}

class _APMSClientsScreenState extends State<APMSClientsScreen> {
  String _selectedFilter = 'All Clients';

  final List<String> _filters = ['All Clients', 'Active', 'Leads', 'High Risk'];

  final List<Map<String, dynamic>> _allClients = const [
    {
      'name': 'Robert Vance',
      'caseType': 'Corporate Litigation',
      'tagText': 'HIGH VALUE',
      'tagBgColor': Color(0xFFEFF6FF),
      'tagTextColor': Color(0xFF2563EB),
      'activeCases': '3 Active',
      'rightLabel': 'Pending Fee',
      'rightValue': '\$500.00',
      'rightValueColor': Color(0xFF2563EB),
      'imageUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=80',
      'isActive': true,
      'isLead': false,
      'isHighRisk': false,
    },
    {
      'name': 'Elena Rodriguez',
      'caseType': 'Real Estate Dispute',
      'tagText': 'NEW CLIENT',
      'tagBgColor': Color(0xFFFEE2E2),
      'tagTextColor': Color(0xFFDC2626),
      'activeCases': '1 Active',
      'rightLabel': 'Pending Fee',
      'rightValue': '\$1,200.00',
      'rightValueColor': Color(0xFFDC2626),
      'imageUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=80',
      'isActive': true,
      'isLead': false,
      'isHighRisk': true,
    },
    {
      'name': 'Arthur Sterling',
      'caseType': 'Trusts & Estates',
      'tagText': 'LOW RISK',
      'tagBgColor': Color(0xFFEFF6FF),
      'tagTextColor': Color(0xFF2563EB),
      'activeCases': '8 Active',
      'rightLabel': 'Pending Fee',
      'rightValue': '\$0.00',
      'rightValueColor': Color(0xFF6B7280),
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=80',
      'isActive': true,
      'isLead': false,
      'isHighRisk': false,
    },
    {
      'name': 'Julian Chen',
      'caseType': 'IP Registration',
      'tagText': 'NEW LEAD',
      'tagBgColor': Color(0xFFEFF6FF),
      'tagTextColor': Color(0xFF2563EB),
      'activeCases': '0 Active',
      'rightLabel': 'Status',
      'rightValue': 'Discovery',
      'rightValueColor': Color(0xFF2563EB),
      'imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=80',
      'isActive': false,
      'isLead': true,
      'isHighRisk': false,
    },
    {
      'name': 'Sarah Jenkins',
      'caseType': 'Contract Review',
      'tagText': 'HIGH VALUE',
      'tagBgColor': Color(0xFFEFF6FF),
      'tagTextColor': Color(0xFF2563EB),
      'activeCases': '2 Active',
      'rightLabel': 'Pending Fee',
      'rightValue': '\$200.00',
      'rightValueColor': Color(0xFF2563EB),
      'imageUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=80',
      'isActive': true,
      'isLead': false,
      'isHighRisk': false,
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
    final filteredClients = _allClients.where((c) {
      if (_selectedFilter == 'All Clients') return true;
      if (_selectedFilter == 'Active') return c['isActive'] as bool;
      if (_selectedFilter == 'Leads') return c['isLead'] as bool;
      if (_selectedFilter == 'High Risk') return c['isHighRisk'] as bool;
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const APMSAddClientScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.person_add_alt_1, color: Colors.black, size: 18),
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
                          'Clients',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'MANAGEMENT',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            letterSpacing: 0.5,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
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
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: const [
                                Icon(Icons.filter_list, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Filter',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...filteredClients.map((c) {
                        return ClientListItemCard(
                          name: c['name'] as String,
                          caseType: c['caseType'] as String,
                          tagText: c['tagText'] as String,
                          tagBgColor: c['tagBgColor'] as Color,
                          tagTextColor: c['tagTextColor'] as Color,
                          activeCases: c['activeCases'] as String,
                          rightLabel: c['rightLabel'] as String,
                          rightValue: c['rightValue'] as String,
                          rightValueColor: c['rightValueColor'] as Color,
                          imageUrl: c['imageUrl'] as String,
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
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final filteredClients = _allClients.where((c) {
      if (_selectedFilter == 'All Clients') return true;
      if (_selectedFilter == 'Active') return c['isActive'] as bool;
      if (_selectedFilter == 'Leads') return c['isLead'] as bool;
      if (_selectedFilter == 'High Risk') return c['isHighRisk'] as bool;
      return true;
    }).toList();

    return DesktopLayoutWrapper(
      activeMenu: 'Clients',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Clients',
                        style: TextStyle(
                          color: Color(0xFF0F1E36),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const APMSAddClientScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.person_add_alt_1_outlined, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Add Client',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: filteredClients.map((c) {
                      return SizedBox(
                        width: cardWidth,
                        child: ClientListItemCard(
                          name: c['name'] as String,
                          caseType: c['caseType'] as String,
                          tagText: c['tagText'] as String,
                          tagBgColor: c['tagBgColor'] as Color,
                          tagTextColor: c['tagTextColor'] as Color,
                          activeCases: c['activeCases'] as String,
                          rightLabel: c['rightLabel'] as String,
                          rightValue: c['rightValue'] as String,
                          rightValueColor: c['rightValueColor'] as Color,
                          imageUrl: c['imageUrl'] as String,
                        ),
                      );
                    }).toList(),
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
