import 'package:flutter/material.dart';
import 'package:advocate_app/widgets/shared_widgets.dart';
import 'package:advocate_app/screens/clients_screen.dart';
import 'package:advocate_app/screens/add_case_screen.dart';
import 'package:advocate_app/services/api_service.dart';

class APMSAddClientScreen extends StatefulWidget {
  const APMSAddClientScreen({super.key});

  @override
  State<APMSAddClientScreen> createState() => _APMSAddClientScreenState();
}

class _APMSAddClientScreenState extends State<APMSAddClientScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _occupationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _occupationController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _saveClient({bool navigateToAddCase = false}) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client Name is required')),
      );
      return;
    }

    final newClient = {
      'name': name,
      'caseType': _occupationController.text.trim().isNotEmpty
          ? _occupationController.text.trim()
          : 'General Legal',
      'tagText': 'NEW CLIENT',
      'tagBgColor': '0xFFFEE2E2',
      'tagTextColor': '0xFFDC2626',
      'activeCases': '0 Active',
      'rightLabel': 'Pending Fee',
      'rightValue': '\$0.00',
      'rightValueColor': '0xFF6B7280',
      'imageUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=80',
      'isActive': true,
      'isLead': false,
      'isHighRisk': false,
    };

    final success = await ApiService.addClient(newClient);
    if (success) {
      if (mounted) {
        if (navigateToAddCase) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const APMSAddCaseScreen()),
          );
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save client to server')),
        );
      }
    }
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const APMSClientsScreen()),
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
                              Icon(Icons.people_outline, color: Colors.black, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Clients',
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
                          'Add Clients',
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
                              ),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Client Photo',
                                    style: TextStyle(color: Color(0xFF0F1E36), fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Upload client photograph',
                                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 32,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      child: const Text(
                                        'Upload Photo',
                                        style: TextStyle(color: Color(0xFF374151), fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormCard(
                        title: 'Personal Information',
                        subtitle: 'Start by identifying the primary client profile.',
                        children: [
                          CustomFormTextField(
                            label: 'Full Legal Name',
                            hintText: 'e.g., Alexander Hamilton',
                            subtext: 'As per official identification documents.',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Identification (Aadhaar/ID)',
                            hintText: 'XXXX-XXXX-XXXX',
                            controller: _idController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Occupation',
                            hintText: 'e.g., Software Engineer',
                            controller: _occupationController,
                          ),
                        ],
                      ),
                      FormCard(
                        title: 'Contact Details',
                        children: [
                          CustomFormTextField(
                            label: 'Mobile Number',
                            hintText: '+91 XXXXX XXXXX',
                            subtext: 'As per official identification documents.',
                            controller: _mobileController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'WhatsApp Number',
                            hintText: '+91 XXXXX XXXXX',
                            controller: _whatsappController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            label: 'Email Address',
                            hintText: 'email@example.com',
                            controller: _emailController,
                          ),
                        ],
                      ),
                      FormCard(
                        title: 'ADDRESS',
                        children: [
                          CustomFormTextField(
                            label: 'Address',
                            hintText: 'Street / Area',
                            prefixIcon: Icons.location_on_outlined,
                            controller: _addressController,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomFormTextField(
                                  label: 'City',
                                  hintText: 'City',
                                  controller: _cityController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomFormTextField(
                                  label: 'State',
                                  hintText: 'State',
                                  controller: _stateController,
                                ),
                              ),
                            ],
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
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => _saveClient(navigateToAddCase: false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save Client',
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
                                onPressed: () => _saveClient(navigateToAddCase: true),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Save & Add Case',
                                  style: TextStyle(color: Color(0xFF374151), fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
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
      activeMenu: 'Clients',
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
                    'Add Clients',
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
                      'Cancel',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
                                ),
                                child: const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Client Photo',
                                      style: TextStyle(color: Color(0xFF0F1E36), fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Upload client photograph',
                                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 32,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                        child: const Text(
                                          'Upload Photo',
                                          style: TextStyle(color: Color(0xFF374151), fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        FormCard(
                          title: 'Personal Information',
                          subtitle: 'Start by identifying the primary client profile.',
                          children: [
                            CustomFormTextField(
                              label: 'Full Legal Name',
                              hintText: 'e.g., Alexander Hamilton',
                              subtext: 'As per official identification documents.',
                              controller: _nameController,
                            ),
                            const SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Identification (Aadhaar/ID)',
                              hintText: 'XXXX-XXXX-XXXX',
                              controller: _idController,
                            ),
                            const SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Occupation',
                              hintText: 'e.g., Software Engineer',
                              controller: _occupationController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        FormCard(
                          title: 'Contact Details',
                          children: [
                            CustomFormTextField(
                              label: 'Mobile Number',
                              hintText: '+91 XXXXX XXXXX',
                              subtext: 'As per official identification documents.',
                              controller: _mobileController,
                            ),
                            const SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'WhatsApp Number',
                              hintText: '+91 XXXXX XXXXX',
                              controller: _whatsappController,
                            ),
                            const SizedBox(height: 16),
                            CustomFormTextField(
                              label: 'Email Address',
                              hintText: 'email@example.com',
                              controller: _emailController,
                            ),
                          ],
                        ),
                        FormCard(
                          title: 'ADDRESS',
                          children: [
                            CustomFormTextField(
                              label: 'Address',
                              hintText: 'Street / Area',
                              prefixIcon: Icons.location_on_outlined,
                              controller: _addressController,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomFormTextField(
                                    label: 'City',
                                    hintText: 'City',
                                    controller: _cityController,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomFormTextField(
                                    label: 'State',
                                    hintText: 'State',
                                    controller: _stateController,
                                  ),
                                ),
                              ],
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _saveClient(navigateToAddCase: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Client',
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
                        onPressed: () => _saveClient(navigateToAddCase: true),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save & Add Case',
                          style: TextStyle(color: Color(0xFF374151), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
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
