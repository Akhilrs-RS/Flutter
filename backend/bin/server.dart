// ignore_for_file: avoid_print
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:advocate_backend/api_router.dart';
import 'package:advocate_backend/data_store.dart';

void main(List<String> args) async {
  // Initialize Datastore
  final store = DataStore();
  await store.init();
  print('Data store initialized.');

  // Create API Router instance
  final apiRouter = ApiRouter();

  // Create pipeline with Logger, CORS middleware, and API router handler
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(apiRouter.router.call);

  // Bind server to port 8080
  final port = int.tryParse(Platform.environment['PORT'] ?? '5000') ?? 5000;
  final server = await io.serve(handler, '0.0.0.0', port);
  print('Server listening on http://${server.address.host}:${server.port}');
}
