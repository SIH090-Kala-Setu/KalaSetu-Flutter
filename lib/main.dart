import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/fcm_service.dart';
import 'core/storage/storage_providers.dart';
import 'core/network/api_endpoints.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      // Must be registered before runApp on native mobile platforms
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

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
