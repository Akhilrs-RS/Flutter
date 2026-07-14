import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/cases_screen.dart';

class APMSAddCaseScreen extends StatefulWidget {
  const APMSAddCaseScreen({super.key});

  @override
  State<APMSAddCaseScreen> createState() => _APMSAddCaseScreenState();
}

class _APMSAddCaseScreenState extends State<APMSAddCaseScreen> {
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const APMSCasesScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: const [
                              Icon(Icons.gavel, color: Colors.black, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'View cases',
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
                          'Add Case',
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
                ],
              ),
            ),
            // Scrollable Form Content
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.light,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      const FormCard(
                        title: 'Case Information',
                        children: [
                          CustomFormTextField(
                            label: 'Case Number',
                            hintText: 'CR-2026-001',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Case Type',
                            hintText: 'Civil',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Court',
                            hintText: 'District Court ,City',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Judge',
                            hintText: 'Hon. Justice Name',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Filing Date',
                            hintText: 'dd-mm-yyyy',
                          ),
                        ],
                      ),
                      const FormCard(
                        title: 'Parties',
                        children: [
                          CustomFormTextField(
                            label: 'Client Name',
                            hintText: 'Client name',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Opposite Party',
                            hintText: 'Opposite party name',
                          ),
                          SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Opposite Advocate',
                            hintText: 'Advocate name',
                          ),
                        ],
                      ),
                      FormCard(
                        title: 'Details',
                        children: [
                          const CustomFormTextField(
                            label: 'Description',
                            hintText: 'Case Description.....',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(
                                child: CustomFormTextField(
                                  label: 'Status',
                                  hintText: 'Open',
                                  suffixIcon: Icons.keyboard_arrow_down,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: CustomFormTextField(
                                  label: 'Priority',
                                  hintText: 'Medium',
                                  suffixIcon: Icons.keyboard_arrow_down,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const CustomFormTextField(
                            label: 'Next Hearing Date',
                            hintText: 'dd-mm-yyyy',
                            suffixIcon: Icons.calendar_today_outlined,
                          ),
                        ],
                      ),
                      FormCard(
                        title: 'DOCUMENTS',
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(Icons.cloud_upload_outlined, color: Colors.blue.shade600, size: 28),
                                const SizedBox(height: 12),
                                const Text(
                                  'Upload Documents',
                                  style: TextStyle(color: Color(0xFF374151), fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'ID proof, address proof, photos',
                                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Case',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.bold),
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
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Case',
                    style: TextStyle(
                      color: Color(0xFF0F1E36),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      'View cases',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Two-Column Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      children: [
                        const FormCard(
                          title: 'Case Information',
                          children: [
                            CustomFormTextField(
                              label: 'Case Number',
                              hintText: 'CR-2026-001',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Case Type',
                              hintText: 'Civil',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Court',
                              hintText: 'District Court ,City',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Judge',
                              hintText: 'Hon. Justice Name',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Filing Date',
                              hintText: 'dd-mm-yyyy',
                            ),
                          ],
                        ),
                        FormCard(
                          title: 'DOCUMENTS',
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(Icons.cloud_upload_outlined, color: Colors.blue.shade600, size: 28),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Upload Documents',
                                    style: TextStyle(color: Color(0xFF374151), fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'ID proof, address proof, photos',
                                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons inside the Left Column
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save Case',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Column
                  Expanded(
                    child: Column(
                      children: [
                        const FormCard(
                          title: 'Parties',
                          children: [
                            CustomFormTextField(
                              label: 'Client Name',
                              hintText: 'Client name',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Opposite Party',
                              hintText: 'Opposite party name',
                            ),
                            SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Opposite Advocate',
                              hintText: 'Advocate name',
                            ),
                          ],
                        ),
                        FormCard(
                          title: 'Details',
                          children: [
                            const CustomFormTextField(
                              label: 'Description',
                              hintText: 'Case Description.....',
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Expanded(
                                  child: CustomFormTextField(
                                    label: 'Status',
                                    hintText: 'Open',
                                    suffixIcon: Icons.keyboard_arrow_down,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: CustomFormTextField(
                                    label: 'Priority',
                                    hintText: 'Medium',
                                    suffixIcon: Icons.keyboard_arrow_down,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const CustomFormTextField(
                              label: 'Next Hearing Date',
                              hintText: 'dd-mm-yyyy',
                              suffixIcon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
