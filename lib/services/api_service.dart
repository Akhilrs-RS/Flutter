// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5001/api';

  // 1. Cases
  static Future<List<Map<String, dynamic>>> getCases() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/cases'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching cases: $e');
    }
    return [];
  }

  static Future<bool> addCase(Map<String, dynamic> caseData) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/cases'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(caseData),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error adding case: $e');
    }
    return false;
  }

  // 2. Clients
  static Future<List<Map<String, dynamic>>> getClients() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/clients'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching clients: $e');
    }
    return [];
  }

  static Future<bool> addClient(Map<String, dynamic> clientData) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/clients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clientData),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error adding client: $e');
    }
    return false;
  }

  // 3. Reminders
  static Future<List<Map<String, dynamic>>> getReminders() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/reminders'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching reminders: $e');
    }
    return [];
  }

  static Future<bool> addReminder(Map<String, dynamic> reminderData) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/reminders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reminderData),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error adding reminder: $e');
    }
    return false;
  }

  static Future<bool> toggleReminderCompletion(String title, bool isCompleted) async {
    return updateReminder(title, {'isCompleted': isCompleted});
  }

  static Future<bool> updateReminder(String title, Map<String, dynamic> updateData) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/reminders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, ...updateData}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error updating reminder: $e');
    }
    return false;
  }

  static Future<bool> deleteReminder(String title) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/reminders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error deleting reminder: $e');
    }
    return false;
  }

  // 4. Notifications
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/notifications'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching notifications: $e');
    }
    return [];
  }

  // 5. Hearings
  static Future<List<Map<String, dynamic>>> getHearings() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/hearings'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching hearings: $e');
    }
    return [];
  }

  static Future<bool> addHearing(Map<String, dynamic> hearingData) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/hearings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(hearingData),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error adding hearing: $e');
    }
    return false;
  }

  static Future<bool> updateHearing(String caseNo, Map<String, dynamic> updateData) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/hearings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'caseNo': caseNo, ...updateData}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error updating hearing: $e');
    }
    return false;
  }

  // 6. Visits
  static Future<List<Map<String, dynamic>>> getVisits() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/visits'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching visits: $e');
    }
    return [];
  }

  static Future<bool> addVisit(Map<String, dynamic> visitData) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/visits'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(visitData),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Network error adding visit: $e');
    }
    return false;
  }

  // 7. FIR Details
  static Future<Map<String, dynamic>> getFIRDetails() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/fir'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Network error fetching FIR details: $e');
    }
    return {};
  }

  // 8. Evidence list
  static Future<List<Map<String, dynamic>>> getEvidence() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/evidence'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('Network error fetching evidence: $e');
    }
    return [];
  }

  // 9. User Authentication
  static Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrPhone': emailOrPhone,
          'password': password,
        }),
      );
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      print('Network error login: $e');
    }
    return {'success': false, 'message': 'Connection error.'};
  }

  static Future<Map<String, dynamic>> register(String name, String email, String phone, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      print('Network error register: $e');
    }
    return {'success': false, 'message': 'Connection error.'};
  }

  static Future<Map<String, dynamic>> verifyOTP(String code) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
        }),
      );
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      print('Network error verify OTP: $e');
    }
    return {'success': false, 'message': 'Connection error.'};
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/auth/me'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['user'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print('Network error fetching current user: $e');
    }
    return {};
  }
}
