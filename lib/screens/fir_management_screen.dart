import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/police_visits_screen.dart';
import 'package:advocate_app/screens/investigation_tracker_screen.dart';
import 'package:advocate_app/screens/evidence_screen.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSFIRManagementScreen extends StatefulWidget {
  const APMSFIRManagementScreen({super.key});

  @override
  State<APMSFIRManagementScreen> createState() => _APMSFIRManagementScreenState();
}

class _APMSFIRManagementScreenState extends State<APMSFIRManagementScreen> {
  Map<String, dynamic> _firDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchFIR();
  }

  void _fetchFIR() async {
    final data = await ApiService.getFIRDetails();
    if (data.isNotEmpty) {
      if (mounted) {
        setState(() {
          _firDetails = data;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _firDetails = Map<String, dynamic>.from(_mockFirDetails);
        });
      }
    }
  }

  final Map<String, dynamic> _mockFirDetails = const {
    'firNumber': '2026/047',
    'caseNumber': 'CR-2026/047/MH/084',
    'policeStation': 'Andheri Police Station',
    'firDate': 'January 10, 2026',
    'legalSections': 'IPC 302, 34',
    'complaintType': 'Cognizable Offence',
    'complainant': 'Rajan Sharma',
    'accused': 'Suresh Rao',
    'victim': 'Rajan Sharma',
    'witnesses': '3 witnesses recorded',
    'ioName': 'Ramesh Patil',
    'status': 'Under Investigation',
  };
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
                          'FIR Management',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'First Information Reports',
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
                      _buildTopTabs(context, 'FIR Management'),
                      const SizedBox(height: 24),
                      _buildFIRDetailsCard(),
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
              _buildTopTabs(context, 'FIR Management'),
              const SizedBox(height: 32),
              _buildDesktopFIRCard(),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('FIR Copy uploaded successfully!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cloud_upload_outlined, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Upload FIR Copy',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Case Brief prepared!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E7EB),
                        foregroundColor: const Color(0xFF374151),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.remove_red_eye_outlined, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'View Copy',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildDesktopFIRCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Red Alert Status Bar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCA5A5), width: 1.0),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FIR No. ${_firDetails['firNumber'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF0F1E36),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _firDetails['policeStation'] ?? '',
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              _firDetails['status'] ?? '',
                              style: const TextStyle(
                                color: Color(0xFFD97706),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Split columns for FIR Details and Parties Involved
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FIR DETAILS',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMetaRow('FIR Number', _firDetails['firNumber'] ?? ''),
                    _buildMetaRow('Police Station', _firDetails['policeStation'] ?? ''),
                    _buildMetaRow('Officer Incharge', _firDetails['ioName'] ?? ''),
                    _buildMetaRow('FIR Date', _firDetails['firDate'] ?? ''),
                    _buildMetaRow('IPC Section', _firDetails['legalSections'] ?? ''),
                    _buildMetaRow('Complaint Type', _firDetails['complaintType'] ?? ''),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STATUS OVERVIEW',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPartyRow('Complainant', _firDetails['complainant'] ?? '', isLink: true),
                    _buildPartyRow('Accused', _firDetails['accused'] ?? '', isRed: true),
                    _buildPartyRow('Witnesses', _firDetails['witnesses'] ?? '', isLink: true),
                    _buildPartyRow('Evidence', '12 items collected', isLink: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFIRDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Box
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A), width: 1.0),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FIR No. ${_firDetails['firNumber'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF0F1E36),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _firDetails['policeStation'] ?? '',
                            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                          ),
                          Text(
                            _firDetails['status'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // FIR Details Section
          const Text(
            'FIR DETAILS',
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildMetaRow('FIR Number', _firDetails['firNumber'] ?? ''),
          _buildMetaRow('Case Number', _firDetails['caseNumber'] ?? ''),
          _buildMetaRow('Police Station', _firDetails['policeStation'] ?? ''),
          _buildMetaRow('FIR Date', _firDetails['firDate'] ?? ''),
          _buildMetaRow('Legal Sections', _firDetails['legalSections'] ?? ''),
          _buildMetaRow('Complaint Type', _firDetails['complaintType'] ?? ''),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 24),
          // Parties Involved
          const Text(
            'PARTIES INVOLVED',
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildPartyRow('Complainant', _firDetails['complainant'] ?? '', isLink: true),
          _buildPartyRow('Accused', _firDetails['accused'] ?? '', isRed: true),
          _buildPartyRow('Victim', _firDetails['victim'] ?? '', isLink: true),
          _buildPartyRow('Witnesses', _firDetails['witnesses'] ?? '', isLink: true),
          _buildPartyRow('IO Name', _firDetails['ioName'] ?? '', isLink: true),
          const SizedBox(height: 24),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('FIR Copy uploaded successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Upload FIR Copy',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Viewing FIR Copy...')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.remove_red_eye_outlined, color: Color(0xFF374151), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'View Copy',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13,
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
    );
  }

  Widget _buildMetaRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(
                color: Color(0xFF0F1E36),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyRow(String label, String val, {bool isLink = false, bool isRed = false}) {
    Color textColor = const Color(0xFF0F1E36);
    if (isLink) {
      textColor = const Color(0xFF2563EB);
    } else if (isRed) {
      textColor = const Color(0xFFDC2626);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
