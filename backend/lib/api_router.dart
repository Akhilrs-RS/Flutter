import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'data_store.dart';

class ApiRouter {
  final DataStore _store = DataStore();

  Router get router {
    final router = Router();

    // CORS preflight helper
    router.all('/<ignored|.*>', (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
        });
      }
      return Response.notFound('Not Found');
    });

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
