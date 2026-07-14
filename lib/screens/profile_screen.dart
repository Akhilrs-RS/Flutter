import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/sign_in_screen.dart';
import 'package:advocate_app/screens/cases_screen.dart';
import 'package:advocate_app/screens/calendar_screen.dart';
import 'package:advocate_app/screens/notifications_screen.dart';

class APMSProfileScreen extends StatelessWidget {
  const APMSProfileScreen({super.key});

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Color(0xFF0F1E36),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GestureDetector(
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
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Adv. Aditi Rao',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enrollment No . D/1421/2014',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          bottom: 12,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit_note, color: Colors.white, size: 20),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(child: _buildStatItem('64', 'Cases')),
                            Container(width: 1, height: 28, color: const Color(0xFFE5E7EB)),
                            Expanded(child: _buildStatItem('128', 'Clients')),
                            Container(width: 1, height: 28, color: const Color(0xFFE5E7EB)),
                            Expanded(child: _buildStatItem('11 yrs', 'Practice')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                        ),
                        child: ProfileRowItem(
                          icon: Icons.currency_rupee,
                          iconColor: const Color(0xFF4B5563),
                          iconBgColor: const Color(0xFFF3F4F6),
                          title: 'Payments',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                        ),
                        child: ProfileRowItem(
                          icon: Icons.stars_outlined,
                          iconColor: const Color(0xFF4B5563),
                          iconBgColor: const Color(0xFFF3F4F6),
                          title: 'Subscriptions',
                          subtitle: 'Explore premium benefits',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProfileSection(
                        title: 'ACCOUNT',
                        children: [
                          ProfileRowItem(
                            icon: Icons.person_outline,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Edit Profile',
                            subtitle: 'Name, photo, contact',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.lock_outline,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Change Password',
                            subtitle: 'Security settings',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.fingerprint,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Biometric Login',
                            subtitle: 'Enabled',
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: const Text(
                                'ON',
                                style: TextStyle(
                                  color: Color(0xFF065F46),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ProfileSection(
                        title: 'PREFERENCES',
                        children: [
                          ProfileRowItem(
                            icon: Icons.notifications_none,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Notification Settings',
                            subtitle: 'Hearing, police, billing alerts',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.dark_mode_outlined,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Dark Mode',
                            subtitle: 'System default',
                            trailing: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: const Text(
                                'Auto',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.language,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Language',
                            subtitle: 'English',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ProfileSection(
                        title: 'DATA',
                        children: [
                          ProfileRowItem(
                            icon: Icons.storage_outlined,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Backup & Sync',
                            subtitle: 'Last backup: Today, 9:41 AM',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.archive_outlined,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Export Data',
                            subtitle: 'Download all case data',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ProfileSection(
                        title: 'ABOUT',
                        children: [
                          ProfileRowItem(
                            icon: Icons.shield_outlined,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Privacy Policy',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.description_outlined,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Terms of Service',
                            onTap: () {},
                          ),
                          ProfileRowItem(
                            icon: Icons.star_outline,
                            iconColor: const Color(0xFF4B5563),
                            iconBgColor: const Color(0xFFF3F4F6),
                            title: 'Rate APMS',
                            subtitle: 'Version 2.4.1',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const APMSSignInScreen()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF2F2),
                            foregroundColor: const Color(0xFFEF4444),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFFFEE2E2), width: 1.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.logout, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Logout from APMS',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
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
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF9CA3AF), size: 26),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const APMSNotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded, color: Colors.black, size: 26),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return DesktopLayoutWrapper(
      activeMenu: 'Profile',
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
                'Profile',
                style: TextStyle(
                  color: Color(0xFF0F1E36),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=120',
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Adv. Aditi Rao',
                            style: TextStyle(
                              color: Color(0xFF0F1E36),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enrollment No . D/1421/2014',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFE5E7EB), height: 1),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('64', 'Cases'),
                              _buildStatItem('128', 'Clients'),
                              _buildStatItem('11 yrs', 'Practice'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ProfileSection(
                          title: 'ACCOUNT',
                          children: [
                            ProfileRowItem(
                              icon: Icons.person_outline,
                              iconColor: const Color(0xFF4B5563),
                              iconBgColor: const Color(0xFFF3F4F6),
                              title: 'Edit Profile',
                              subtitle: 'Name, photo, contact',
                              onTap: () {},
                            ),
                            ProfileRowItem(
                              icon: Icons.lock_outline,
                              iconColor: const Color(0xFF4B5563),
                              iconBgColor: const Color(0xFFF3F4F6),
                              title: 'Change Password',
                              subtitle: 'Security settings',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ProfileSection(
                          title: 'PREFERENCES',
                          children: [
                            ProfileRowItem(
                              icon: Icons.notifications_none,
                              iconColor: const Color(0xFF4B5563),
                              iconBgColor: const Color(0xFFF3F4F6),
                              title: 'Notification Settings',
                              subtitle: 'Hearing, police, billing alerts',
                              onTap: () {},
                            ),
                            ProfileRowItem(
                              icon: Icons.language,
                              iconColor: const Color(0xFF4B5563),
                              iconBgColor: const Color(0xFFF3F4F6),
                              title: 'Language',
                              subtitle: 'English',
                              onTap: () {},
                            ),
                          ],
                        ),
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
