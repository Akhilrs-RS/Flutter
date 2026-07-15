// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

class DataStore {
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  final File _file = File('data.json');

  List<Map<String, dynamic>> cases = [];
  List<Map<String, dynamic>> clients = [];
  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> hearings = [];
  List<Map<String, dynamic>> visits = [];
  Map<String, dynamic> firDetails = {};
  List<Map<String, dynamic>> evidence = [];
  List<Map<String, dynamic>> monthEvents = [];
  List<Map<String, dynamic>> users = [];

  Future<void> init() async {
    if (await _file.exists()) {
      try {
        final content = await _file.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;
        
        cases = List<Map<String, dynamic>>.from(data['cases'] ?? []);
        clients = List<Map<String, dynamic>>.from(data['clients'] ?? []);
        reminders = List<Map<String, dynamic>>.from(data['reminders'] ?? []);
        notifications = List<Map<String, dynamic>>.from(data['notifications'] ?? []);
        hearings = List<Map<String, dynamic>>.from(data['hearings'] ?? []);
        visits = List<Map<String, dynamic>>.from(data['visits'] ?? []);
        firDetails = Map<String, dynamic>.from(data['firDetails'] ?? {});
        evidence = List<Map<String, dynamic>>.from(data['evidence'] ?? []);
        monthEvents = List<Map<String, dynamic>>.from(data['monthEvents'] ?? []);
        users = List<Map<String, dynamic>>.from(data['users'] ?? []);
        return;
      } catch (e) {
        print('Error reading data.json, falling back to mock data: $e');
      }
    }
    
    // Load default mock data
    _loadMockData();
    await save();
  }

  Future<void> save() async {
    final data = {
      'cases': cases,
      'clients': clients,
      'reminders': reminders,
      'notifications': notifications,
      'hearings': hearings,
      'visits': visits,
      'firDetails': firDetails,
      'evidence': evidence,
      'monthEvents': monthEvents,
      'users': users,
    };
    await _file.writeAsString(jsonEncode(data));
  }

  void _loadMockData() {
    cases = [
      {
        'caseNo': 'CR-2024-8842-DL',
        'title': 'State vs. Harrison Miller',
        'court': 'Delhi High Court - Room 4B',
        'nextDate': 'Next: Oct 24, 2026',
        'clientName': 'Harrison Miller',
        'clientPhoto': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=120',
        'status': 'Active',
        'statusBgColor': '0xFFD1FAE5',
        'statusTextColor': '0xFF065F46',
        'leftStripColor': '0xFF10B981',
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
        'statusBgColor': '0xFFD1FAE5',
        'statusTextColor': '0xFF065F46',
        'leftStripColor': '0xFF10B981',
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
        'statusBgColor': '0xFFFEF3C7',
        'statusTextColor': '0xFFD97706',
        'leftStripColor': '0xFFF59E0B',
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
        'statusBgColor': '0xFFF3E8FF',
        'statusTextColor': '0xFF7C3AED',
        'leftStripColor': '0xFF7C3AED',
        'isHearingToday': false,
        'isPending': false,
        'isAppealed': true,
      },
    ];

    clients = [
      {
        'name': 'Robert Vance',
        'caseType': 'Corporate Litigation',
        'tagText': 'HIGH VALUE',
        'tagBgColor': '0xFFEFF6FF',
        'tagTextColor': '0xFF2563EB',
        'activeCases': '3 Active',
        'rightLabel': 'Pending Fee',
        'rightValue': '\$500.00',
        'rightValueColor': '0xFF2563EB',
        'imageUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=80',
        'isActive': true,
        'isLead': false,
        'isHighRisk': false,
      },
      {
        'name': 'Elena Rodriguez',
        'caseType': 'Real Estate Dispute',
        'tagText': 'NEW CLIENT',
        'tagBgColor': '0xFFFEE2E2',
        'tagTextColor': '0xFFDC2626',
        'activeCases': '1 Active',
        'rightLabel': 'Pending Fee',
        'rightValue': '\$1,200.00',
        'rightValueColor': '0xFFDC2626',
        'imageUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=80',
        'isActive': true,
        'isLead': false,
        'isHighRisk': true,
      },
      {
        'name': 'Arthur Sterling',
        'caseType': 'Trusts & Estates',
        'tagText': 'LOW RISK',
        'tagBgColor': '0xFFEFF6FF',
        'tagTextColor': '0xFF2563EB',
        'activeCases': '8 Active',
        'rightLabel': 'Pending Fee',
        'rightValue': '\$0.00',
        'rightValueColor': '0xFF6B7280',
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=80',
        'isActive': true,
        'isLead': false,
        'isHighRisk': false,
      },
      {
        'name': 'Julian Chen',
        'caseType': 'IP Registration',
        'tagText': 'NEW LEAD',
        'tagBgColor': '0xFFEFF6FF',
        'tagTextColor': '0xFF2563EB',
        'activeCases': '0 Active',
        'rightLabel': 'Status',
        'rightValue': 'Discovery',
        'rightValueColor': '0xFF2563EB',
        'imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=80',
        'isActive': false,
        'isLead': true,
        'isHighRisk': false,
      },
      {
        'name': 'Sarah Jenkins',
        'caseType': 'Contract Review',
        'tagText': 'HIGH VALUE',
        'tagBgColor': '0xFFEFF6FF',
        'tagTextColor': '0xFF2563EB',
        'activeCases': '2 Active',
        'rightLabel': 'Pending Fee',
        'rightValue': '\$200.00',
        'rightValueColor': '0xFF2563EB',
        'imageUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=80',
        'isActive': true,
        'isLead': false,
        'isHighRisk': false,
      },
    ];

    reminders = [
      {
        'title': 'File Bail Application',
        'priority': 'High',
        'priorityBg': '0xFFFEE2E2',
        'priorityText': '0xFFDC2626',
        'time': 'Jul 16, 2026 @ 09:00 AM',
        'tag': 'Case',
        'tagBg': '0xFFEFF6FF',
        'tagText': '0xFF2563EB',
        'subtitle': 'Client: Priya Mehta',
        'isCompleted': false,
      },
      {
        'title': 'Hearing - CR-2026-047',
        'priority': 'High',
        'priorityBg': '0xFFFEE2E2',
        'priorityText': '0xFFDC2626',
        'time': 'Jul 15, 2026 @ 10:30 AM',
        'tag': 'Hearing',
        'tagBg': '0xFFF5F3FF',
        'tagText': '0xFF7C3AED',
        'subtitle': '1 day before',
        'isCompleted': false,
      },
      {
        'title': 'Collect Payment - Mehta',
        'priority': 'Medium',
        'priorityBg': '0xFFFEF3C7',
        'priorityText': '0xFFD97706',
        'time': 'Jul 12, 2026 @ 04:00 PM',
        'tag': 'Billing',
        'tagBg': '0xFFECFDF5',
        'tagText': '0xFF059669',
        'subtitle': 'None',
        'isCompleted': false,
      },
      {
        'title': 'File Evidence',
        'priority': 'High',
        'priorityBg': '0xFFFEE2E2',
        'priorityText': '0xFFDC2626',
        'time': 'Jul 14, 2026 @ 11:00 AM',
        'tag': 'Case File',
        'tagBg': '0xFFEFF6FF',
        'tagText': '0xFF2563EB',
        'subtitle': 'Completed',
        'isCompleted': true,
      },
    ];

    notifications = [
      {
        'title': 'Hearing Reminder',
        'subtitle': 'CR-2026-047 hearing tomorrow at 10:30 AM – Bombay HC Hall 7',
        'time': '5m ago',
        'type': 'Hearings',
        'isUnread': true,
        'iconBgColor': '0xFFF3E8FF',
        'iconColor': '0xFF9333EA',
        'icon': 'gavel',
      },
      {
        'title': 'Police Visit Due',
        'subtitle': 'Scheduled visit to Andheri PS today at 2:00 PM',
        'time': '12m ago',
        'type': 'Police',
        'isUnread': true,
        'iconBgColor': '0xFFFEF3C7',
        'iconColor': '0xFFD97706',
        'icon': 'shield',
      },
      {
        'title': 'Payment Received',
        'subtitle': '₹15,000 received from Priya Mehta for Case CIV-2026-012',
        'time': '1h ago',
        'type': 'Payments',
        'isUnread': true,
        'iconBgColor': '0xFFD1FAE5',
        'iconColor': '0xFF059669',
        'icon': 'currency_rupee',
      },
      {
        'title': 'Document Uploaded',
        'subtitle': 'FIR copy for Case CR-2026-047 has been uploaded',
        'time': '2h ago',
        'type': 'Docs',
        'isUnread': false,
        'iconBgColor': '0xFFDBEAFE',
        'iconColor': '0xFF2563EB',
        'icon': 'description',
      },
      {
        'title': 'Reminder: File Bail',
        'subtitle': 'Bail application for Ajay Sharma due in 2 days',
        'time': '3h ago',
        'type': 'Reminder',
        'isUnread': false,
        'iconBgColor': '0xFFFEE2E2',
        'iconColor': '0xFFDC2626',
        'icon': 'notifications',
      },
      {
        'title': 'New Client Added',
        'subtitle': 'Vikram Das has been added as a new client',
        'time': '5h ago',
        'type': 'Client',
        'isUnread': false,
        'iconBgColor': '0xFFE0F2FE',
        'iconColor': '0xFF0284C7',
        'icon': 'person',
      },
    ];

    hearings = [
      {
        'caseNo': 'Case #2934-22',
        'title': 'Smith vs. Global Dynamics',
        'court': 'Supreme Court, Room 402',
        'judge': 'Hon. Justice Elena Rodriguez',
        'tag1': 'Cross Examination',
        'tag1Bg': '0xFFEFF6FF',
        'tag1Text': '0xFF2563EB',
        'tag2': 'Confirmed',
        'tag2Bg': '0xFFD1FAE5',
        'tag2Text': '0xFF059669',
        'accentColor': '0xFF10B981',
        'time': '10:30',
        'period': 'AM',
        'showMarkDone': true,
        'firstButtonLabel': 'Update Status',
        'isToday': true,
        'isUpcoming': false,
        'isCompleted': false,
      },
      {
        'caseNo': 'Case #8120-23',
        'title': 'State vs. Marcus Vance',
        'court': 'District Court, Hall B',
        'judge': 'Judge Theodore Wright',
        'tag1': 'Plea & Motion',
        'tag1Bg': '0xFFEFF6FF',
        'tag1Text': '0xFF3B82F6',
        'tag2': 'Pending',
        'tag2Bg': '0xFFFEF3C7',
        'tag2Text': '0xFFD97706',
        'accentColor': '0xFFF59E0B',
        'time': '02:15',
        'period': 'PM',
        'showMarkDone': true,
        'firstButtonLabel': 'Reschedule',
        'isToday': true,
        'isUpcoming': false,
        'isCompleted': false,
      },
      {
        'caseNo': 'Case #5541-21',
        'title': 'Riverside HOA vs. Park',
        'court': 'Civil Court, Room 12',
        'judge': 'Judge Sarah Miller',
        'tag1': 'Bail List',
        'tag1Bg': '0xFFEFF6FF',
        'tag1Text': '0xFF3B82F6',
        'tag2': 'Adjourned',
        'tag2Bg': '0xFFF3F4F6',
        'tag2Text': '0xFF6B7280',
        'accentColor': '0xFF9CA3AF',
        'time': '04:45',
        'period': 'PM',
        'showMarkDone': false,
        'firstButtonLabel': 'Reschedule',
        'isToday': false,
        'isUpcoming': true,
        'isCompleted': false,
      },
      {
        'caseNo': 'Case #2026/047',
        'title': 'State vs. Rajan Sharma',
        'court': 'Bombay High Court',
        'judge': 'Judge Ramesh Patil',
        'tag1': 'Bail Application',
        'tag1Bg': '0xFFEFF6FF',
        'tag1Text': '0xFF2563EB',
        'tag2': 'Completed',
        'tag2Bg': '0xFFD1FAE5',
        'tag2Text': '0xFF065F46',
        'accentColor': '0xFF10B981',
        'time': '10:30',
        'period': 'AM',
        'showMarkDone': false,
        'isToday': false,
        'isUpcoming': false,
        'isCompleted': true,
        'note': 'Hearing completed successfully',
      },
    ];

    visits = [
      {
        'title': 'Andheri Police Station',
        'subtitle': 'IO Rajesh Patil',
        'tagText': 'Scheduled',
        'tagBgColor': '0xFFE0F2FE',
        'tagTextColor': '0xFF0369A1',
        'caseInfo': 'CR-2026-047 . Jan 10, 2026',
        'timeInfo': '02:00 PM . Witness statement',
      },
      {
        'title': 'Bandra PS',
        'subtitle': 'IO Meera Nair',
        'tagText': 'Completed',
        'tagBgColor': '0xFFD1FAE5',
        'tagTextColor': '0xFF065F46',
        'caseInfo': 'MV-2025-089 . Jul 05, 2025',
        'timeInfo': '11:00 AM . FIR copy collection',
      },
      {
        'title': 'Kurla PS',
        'subtitle': 'IO Suresh Yadav',
        'tagText': 'Pending',
        'tagBgColor': '0xFFFEF3C7',
        'tagTextColor': '0xFFD97706',
        'caseInfo': 'CR-2025-099 . Jul 14, 2026',
        'timeInfo': '10:00 AM . Evidence submission',
      },
    ];

    firDetails = {
      'firNumber': '2026/047',
      'caseNumber': 'CR-2026/047/MH/084',
      'policeStation': 'Andheri West PS',
      'firDate': 'January 10, 2026',
      'legalSections': 'IPC 302, 120B, 34',
      'complaintType': 'Cognizable Offense',
      'complainant': 'Rajan Sharma',
      'accused': 'Unknown Party',
      'victim': 'Rajan Sharma',
      'witnesses': '3 witnesses recorded',
      'ioName': 'IO Rajesh Patil',
      'status': 'Under Investigation',
    };

    evidence = [
      {
        'title': 'CCTV Footage',
        'subtitle': 'Shop premises 8PM - 10PM Jan 08',
        'meta': '# CR-2026-047 . CCTV . 02 members',
        'date': 'Mar 01, 2026',
        'hasShare': true,
      },
      {
        'title': 'Forensic Report',
        'subtitle': 'DNA analysis - positive match',
        'meta': '# CR-2026-047 . DNA & Forensics . 01 file',
        'date': 'Mar 12, 2026',
        'hasShare': true,
      },
      {
        'title': 'Witness Audio',
        'subtitle': 'Statement of key witness Patel',
        'meta': '# MV-2025-089 . Audio . 03 minutes',
        'date': 'Feb 18, 2026',
        'hasShare': true,
      },
    ];

    monthEvents = [
      {
        'time': '10:30',
        'title': 'Sharma vs State',
        'subtitle': 'Bombay HC – Hall 7',
        'accentColor': '0xFF2563EB',
      },
      {
        'time': '14:00',
        'title': 'Police Visit – Andheri PS',
        'subtitle': 'IO Rajesh Patil',
        'accentColor': '0xFFD97706',
      },
      {
        'time': '16:30',
        'title': 'Client Meeting – Mehta',
        'subtitle': 'Office consultation',
        'accentColor': '0xFF10B981',
      },
    ];

    users = [
      {
        'email': 'attorney@firm.com',
        'name': 'Adv. Arjun Mehtha',
        'phone': '9876543210',
        'password': 'password123',
      }
    ];
  }
}
