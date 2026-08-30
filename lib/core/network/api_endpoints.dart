import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  ApiEndpoints._();

  static String _overrideBaseUrl = '';

  /// Allows setting a custom backend URL at runtime (e.g., from settings or env)
  static void setBaseUrl(String url) {
    var clean = url.trim();
    if (clean.isEmpty) {
      _overrideBaseUrl = '';
      return;
    }
    // Prepend http:// if user omitted scheme
    if (!clean.startsWith('http://') && !clean.startsWith('https://')) {
      clean = 'http://$clean';
    }
    // Strip trailing slashes
    while (clean.endsWith('/')) {
      clean = clean.substring(0, clean.length - 1);
    }
    // Auto-fix localhost for Android devices/emulators
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          // If on Android and user typed localhost or 127.0.0.1, auto-map to 10.0.2.2
          clean = clean
              .replaceAll('://localhost', '://10.0.2.2')
              .replaceAll('://127.0.0.1', '://10.0.2.2');
        }
      } catch (_) {}
    }
    _overrideBaseUrl = clean;
  }

  /// Dynamically resolves the active FastAPI backend base URL
  static String get baseUrl {
    if (_overrideBaseUrl.isNotEmpty) {
      return _overrideBaseUrl;
    }

    // 1. Build-time environment variable (e.g. flutter build apk --dart-define=BACKEND_URL=https://api.yourdomain.com)
    const envUrl = String.fromEnvironment('BACKEND_URL');
    if (envUrl.isNotEmpty) {
      var clean = envUrl.trim();
      if (!clean.startsWith('http://') && !clean.startsWith('https://')) {
        clean = 'http://$clean';
      }
      while (clean.endsWith('/')) {
        clean = clean.substring(0, clean.length - 1);
      }
      return clean;
    }

    // 2. Default local development fallbacks
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {}

    // Windows, macOS, Linux, iOS
    return 'http://127.0.0.1:8000';
  }

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';

  // AI Studio & Tools
  static const String enhance = '/enhance';
  static const String enhanceBatch = '/enhance/batch';
  static const String catalog = '/catalog';
  static const String suggestPrice = '/suggest-price';

  // Products
  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';
  static String productStatus(String id) => '/products/$id/status';
  static String productStock(String id) => '/products/$id/stock';
  static String productPrice(String id) => '/products/$id/price';
  static String productQr(String id) => '/products/$id/qr';

  // Inquiries
  static const String inquiries = '/inquiries';
  static String respondInquiry(String id) => '/inquiries/$id/respond';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';

  // Artisan
  static const String artisanDashboard = '/artisan/dashboard';
  static const String artisanProfile = '/artisan/profile';
  static const String artisanAnalytics = '/artisan/analytics';
  static const String artisanReport = '/artisan/report';

  // Aggregator
  static const String aggregatorDashboard = '/aggregator/dashboard';
  static const String aggregatorArtisans = '/aggregator/artisans';
  static const String aggregatorOnboard = '/aggregator/artisans/onboard';
  static const String aggregatorRelayScheme = '/aggregator/schemes/relay';
  static const String aggregatorSubmitReport = '/aggregator/reports/submit';

  // Buyer
  static const String buyerDashboard = '/buyer/dashboard';

  // Clusters
  static const String clusters = '/clusters';
  static const String myClusters = '/clusters/my-clusters';
  static String clusterArtisans(String clusterId) =>
      '/clusters/$clusterId/artisans';
  static String clusterStats(String clusterId) =>
      '/admin/clusters/$clusterId/stats';

  // Exhibitions & Schemes
  static const String exhibitions = '/admin/exhibitions';
  static String registerExhibition(String exhibitionId) =>
      '/admin/exhibitions/$exhibitionId/register';
  static const String schemes = '/admin/schemes';
}
