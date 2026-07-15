import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'data_store.dart';

class ApiRouter {
  final DataStore _store = DataStore();

  Router get router {
    final router = Router();



    // 1. Cases endpoints
    router.get('/api/cases', (Request request) {
      return _jsonResponse(_store.cases);
    });

    router.post('/api/cases', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      _store.cases.insert(0, data);
      await _store.save();
      return _jsonResponse({'success': true, 'data': data});
    });

    // 2. Clients endpoints
    router.get('/api/clients', (Request request) {
      return _jsonResponse(_store.clients);
    });

    router.post('/api/clients', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      _store.clients.insert(0, data);
      await _store.save();
      return _jsonResponse({'success': true, 'data': data});
    });

    // 3. Reminders endpoints
    router.get('/api/reminders', (Request request) {
      return _jsonResponse(_store.reminders);
    });

    router.post('/api/reminders', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      _store.reminders.insert(0, data);
      await _store.save();
      return _jsonResponse({'success': true, 'data': data});
    });

    router.put('/api/reminders', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final title = data['title'] as String;
      final isCompleted = data['isCompleted'] as bool;
      
      for (var reminder in _store.reminders) {
        if (reminder['title'] == title) {
          reminder['isCompleted'] = isCompleted;
          if (isCompleted) {
            reminder['subtitle'] = 'Completed';
          } else {
            reminder['subtitle'] = 'Pending';
          }
          break;
        }
      }
      await _store.save();
      return _jsonResponse({'success': true});
    });

    // 4. Notifications endpoints
    router.get('/api/notifications', (Request request) {
      return _jsonResponse(_store.notifications);
    });

    // 5. Hearings endpoints
    router.get('/api/hearings', (Request request) {
      return _jsonResponse(_store.hearings);
    });

    // 6. Visits endpoints
    router.get('/api/visits', (Request request) {
      return _jsonResponse(_store.visits);
    });

    router.post('/api/visits', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      _store.visits.insert(0, data);
      await _store.save();
      return _jsonResponse({'success': true, 'data': data});
    });

    // 7. FIR details
    router.get('/api/fir', (Request request) {
      return _jsonResponse(_store.firDetails);
    });

    // 8. Evidence list
    router.get('/api/evidence', (Request request) {
      return _jsonResponse(_store.evidence);
    });

    // 9. Auth endpoints
    router.post('/api/auth/register', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final email = data['email'] as String;
      
      // Check if user already exists
      final exists = _store.users.any((u) => u['email'] == email);
      if (exists) {
        return Response.badRequest(body: jsonEncode({'success': false, 'message': 'Email already registered.'}), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        });
      }
      
      _store.users.add(data);
      await _store.save();
      return _jsonResponse({'success': true, 'message': 'Registration successful.'});
    });

    router.post('/api/auth/login', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final emailOrPhone = data['emailOrPhone'] as String;
      final password = data['password'] as String;

      try {
        final user = _store.users.firstWhere(
          (u) => (u['email'] == emailOrPhone || u['phone'] == emailOrPhone) && u['password'] == password,
        );
        return _jsonResponse({
          'success': true,
          'message': 'Login successful.',
          'user': {
            'email': user['email'],
            'name': user['name'],
            'phone': user['phone'],
          }
        });
      } catch (e) {
        return Response.badRequest(body: jsonEncode({'success': false, 'message': 'Invalid credentials.'}), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        });
      }
    });

    router.post('/api/auth/verify', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final code = data['code'] as String;

      if (code == '1234') {
        return _jsonResponse({'success': true, 'message': 'Verification successful.'});
      } else {
        return Response.badRequest(body: jsonEncode({'success': false, 'message': 'Invalid verification code.'}), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        });
      }
    });

    return router;
  }

  Response _jsonResponse(dynamic data) {
    return Response.ok(
      jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
      },
    );
  }
}
