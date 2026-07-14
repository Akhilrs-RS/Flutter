import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/notifications_screen.dart';
import 'package:advocate_app/screens/profile_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/evidence_screen.dart';

class APMSCaseDetailsScreen extends StatelessWidget {
  const APMSCaseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildMobileLayout(context),
      desktopLayout: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'APMS',
          style: TextStyle(
            color: Color(0xFF0F1E36),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black, size: 26),
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
              radius: 18,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=120',
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'State vs. Harrison\nMiller',
                              style: TextStyle(
                                color: Color(0xFF0F1E36),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Georgia',
                                height: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFF065F46),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Case ID: CR-2024-8842-DL',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            CaseFilterTab(label: 'Overview', selected: true),
                            CaseFilterTab(label: 'Timeline', selected: false),
                            CaseFilterTab(label: 'Hearings', selected: false),
                            CaseFilterTab(label: 'Doc', selected: false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const CaseProgressStepper(),
                      const SizedBox(height: 24),
                      _buildUpcomingHearingCard(context),
                      const SizedBox(height: 24),
                      _buildCaseSummaryCard(),
                      const SizedBox(height: 24),
                      const PeopleCard(
                        role: 'Advocate',
                        name: 'John Doe',
                        avatar: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=80',
                          ),
                        ),
                      ),
                      const PeopleCard(
                        role: 'Honorable Judge',
                        name: 'Elena Vance',
                        avatar: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFEFF6FF),
                          child: Icon(Icons.gavel, color: Colors.blue, size: 18),
                        ),
                      ),
                      const PeopleCard(
                        role: 'Opposing Counsel',
                        name: 'Foster & Sterling LLP',
                        avatar: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFFEF2F2),
                          child: Icon(Icons.balance, color: Colors.red, size: 18),
                        ),
                        suffixIcon: Icon(Icons.phone, color: Color(0xFF4B5563), size: 20),
                      ),
                      const SizedBox(height: 12),
                      _buildEvidenceLink(context),
                      const SizedBox(height: 16),
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
              onPressed: () {
                Navigator.of(context).pop();
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
      activeMenu: 'Cases',
      child: Theme(
        data: ThemeData(
          brightness: Brightness.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'State vs. Harrison Miller',
                        style: TextStyle(
                          color: Color(0xFF0F1E36),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Case ID: CR-2024-8842-DL',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  CaseFilterTab(label: 'Overview', selected: true),
                  CaseFilterTab(label: 'Timeline', selected: false),
                  CaseFilterTab(label: 'Hearings', selected: false),
                  CaseFilterTab(label: 'Documents', selected: false),
                  CaseFilterTab(label: 'Billing', selected: false),
                ],
              ),
              const SizedBox(height: 32),
              // Split Content Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Column
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildDesktopCaseProgressStepper(),
                        const SizedBox(height: 24),
                        _buildUpcomingHearingCard(context),
                        const SizedBox(height: 24),
                        // People section card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'People Involved',
                                style: TextStyle(
                                  color: Color(0xFF0F1E36),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              PeopleCard(
                                role: 'Advocate',
                                name: 'John Doe',
                                avatar: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=80',
                                  ),
                                ),
                              ),
                              PeopleCard(
                                role: 'Honorable Judge',
                                name: 'Elena Vance',
                                avatar: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFEFF6FF),
                                  child: Icon(Icons.gavel, color: Colors.blue, size: 18),
                                ),
                              ),
                              PeopleCard(
                                role: 'Opposing Counsel',
                                name: 'Foster & Sterling LLP',
                                avatar: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFFEF2F2),
                                  child: Icon(Icons.balance, color: Colors.red, size: 18),
                                ),
                                suffixIcon: Icon(Icons.phone, color: Color(0xFF4B5563), size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Side Column
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildCaseSummaryCard(),
                        const SizedBox(height: 24),
                        _buildEvidenceLink(context),
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

  Widget _buildDesktopCaseProgressStepper() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Case Progress',
            style: TextStyle(
              color: Color(0xFF0F1E36),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStep('Filing', true, true),
              _buildProgressLine(true),
              _buildProgressStep('Pleadings', true, true),
              _buildProgressLine(true),
              _buildProgressStep('Hearings', true, true),
              _buildProgressLine(false),
              _buildProgressStep('Judgment', false, false),
              _buildProgressLine(false),
              _buildProgressStep('Closed', false, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isCompleted, bool isCurrentActive) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF3B82F6) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF3B82F6)
                  : (isCurrentActive ? const Color(0xFF3B82F6) : const Color(0xFFD1D5DB)),
              width: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? const Color(0xFF0F1E36) : const Color(0xFF9CA3AF),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool active) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        height: 2,
        color: active ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildUpcomingHearingCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 14),
              SizedBox(width: 8),
              Text(
                'UPCOMING HEARING',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Oct 24',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Thursday • 10:30 AM',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'Courtroom 4B',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Judge Elena Vance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit_note, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Prepare Brief',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Case Summary',
            style: TextStyle(
              color: Color(0xFF0F1E36),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Civil litigation regarding contractual dispute in commercial real estate development. Current stage involves secondary evidence submission for phase 1 planning permissions. Adjourned from previous session due to witness unavailability.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceLink(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const APMSEvidenceScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Documents & Evidence',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xFF9CA3AF), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
