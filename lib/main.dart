import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/storage/storage_providers.dart';
import 'core/network/api_endpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Register background FCM handler before runApp
  // (firebaseMessagingBackgroundHandler is top-level in fcm_service.dart)
  
  final sharedPreferences = await SharedPreferences.getInstance();

  final savedUrl = sharedPreferences.getString('custom_backend_url');
  if (savedUrl != null && savedUrl.isNotEmpty) {
    ApiEndpoints.setBaseUrl(savedUrl);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const KalaSetuApp(),
    ),
  );
}
