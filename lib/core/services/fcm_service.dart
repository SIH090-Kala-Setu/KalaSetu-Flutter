import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

/// Top-level handler required by firebase_messaging for background messages.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background: ${message.notification?.title}');
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static final _foregroundStream =
      StreamController<RemoteMessage>.broadcast();
  static Stream<RemoteMessage> get onForegroundMessage =>
      _foregroundStream.stream;

  Future<void> init(WidgetRef ref) async {
    try {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);

      // On Android/iOS, set foreground notification presentation
      if (!kIsWeb) {
        await _fcm.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      final token = await _fcm.getToken();
      if (token != null) await _uploadToken(token, ref);

      _fcm.onTokenRefresh.listen((t) => _uploadToken(t, ref));

      FirebaseMessaging.onMessage.listen((msg) {
        debugPrint('FCM foreground: ${msg.notification?.title}');
        _foregroundStream.add(msg);
      });
    } catch (e) {
      debugPrint('FCM service init notice: $e');
    }
  }

  Future<void> _uploadToken(String token, WidgetRef ref) async {
    try {
      await ref.read(apiClientProvider).registerFcmToken(token);
    } catch (e) {
      debugPrint('FCM token upload failed: $e');
    }
  }
}
