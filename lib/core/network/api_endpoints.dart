class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'http://10.0.2.2:8000'; // Standard Android emulator localhost; override for physical device or web

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
