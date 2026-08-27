import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';

// Onboarding
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/language_picker_screen.dart';
import '../../features/onboarding/presentation/splash_welcome_screen.dart';
import '../../features/onboarding/presentation/role_selection_screen.dart';
import '../../features/onboarding/presentation/phone_entry_screen.dart';
import '../../features/onboarding/presentation/otp_verification_screen.dart';
import '../../features/onboarding/presentation/artisan_registration_wizard.dart';
import '../../features/onboarding/presentation/aggregator_registration_screen.dart';
import '../../features/onboarding/presentation/buyer_registration_screen.dart';
import '../../features/onboarding/presentation/pending_verification_screen.dart';

// Auth
import '../../features/auth/presentation/login_screen.dart';

// Shared
import '../../features/shared/presentation/notifications_screen.dart';

// Artisan
import '../../features/artisan/presentation/artisan_shell.dart';
import '../../features/artisan/presentation/home_screen.dart' as artisan;
import '../../features/artisan/presentation/catalog_screen.dart';
import '../../features/artisan/presentation/inquiries_screen.dart';
import '../../features/artisan/presentation/profile_screen.dart';
import '../../features/artisan/presentation/studio/ai_camera_studio.dart';
import '../../features/artisan/presentation/exhibitions_screen.dart';

// Aggregator
import '../../features/aggregator/presentation/aggregator_shell.dart';
import '../../features/aggregator/presentation/home_screen.dart' as aggregator;
import '../../features/aggregator/presentation/artisans_list_screen.dart';
import '../../features/aggregator/presentation/cluster_analytics_screen.dart';
import '../../features/aggregator/presentation/alerts_reporting_screen.dart';

// Buyer
import '../../features/buyer/presentation/buyer_shell.dart';
import '../../features/buyer/presentation/home_screen.dart' as buyer;
import '../../features/buyer/presentation/product_detail_screen.dart';
import '../../features/buyer/presentation/my_inquiries_screen.dart';
import '../../features/buyer/presentation/buyer_profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _artisanShellNavigatorKey = GlobalKey<NavigatorState>();
final _aggregatorShellNavigatorKey = GlobalKey<NavigatorState>();
final _buyerShellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/splash';
      final isAuthFlow = state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation == '/login';

      if (authState == AuthState.initial) {
        return '/splash';
      }

      if (authState == AuthState.unauthenticated) {
        if (!isAuthFlow) return '/onboarding/language';
        return null;
      }

      if (authState == AuthState.authenticatedArtisan) {
        if (isAuthFlow || isSplash) return '/artisan/home';
        return null;
      }

      if (authState == AuthState.authenticatedAggregator) {
        if (isAuthFlow || isSplash) return '/aggregator/home';
        return null;
      }

      if (authState == AuthState.authenticatedBuyer) {
        if (isAuthFlow || isSplash) return '/buyer/home';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding/language',
        builder: (context, state) => const LanguagePickerScreen(),
      ),
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, state) => const SplashWelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/phone',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'Artisan';
          return PhoneEntryScreen(role: role);
        },
      ),
      GoRoute(
        path: '/onboarding/otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          final role = state.uri.queryParameters['role'] ?? 'Artisan';
          return OtpVerificationScreen(phone: phone, role: role);
        },
      ),
      GoRoute(
        path: '/onboarding/register/artisan',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return ArtisanRegistrationWizard(phone: phone);
        },
      ),
      GoRoute(
        path: '/onboarding/register/aggregator',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return AggregatorRegistrationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/onboarding/register/buyer',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return BuyerRegistrationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/onboarding/pending-verification',
        builder: (context, state) => const PendingVerificationScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ==========================================
      // ARTISAN MODULE
      // ==========================================
      ShellRoute(
        navigatorKey: _artisanShellNavigatorKey,
        builder: (context, state, child) => ArtisanShell(child: child),
        routes: [
          GoRoute(
            path: '/artisan/home',
            builder: (context, state) => const artisan.ArtisanHomeScreen(),
          ),
          GoRoute(
            path: '/artisan/catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: '/artisan/inquiries',
            builder: (context, state) => const InquiriesScreen(),
          ),
          GoRoute(
            path: '/artisan/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/artisan/studio',
        builder: (context, state) => const AiCameraStudioScreen(),
      ),
      GoRoute(
        path: '/artisan/exhibitions',
        builder: (context, state) => const ExhibitionsScreen(),
      ),

      // ==========================================
      // AGGREGATOR MODULE
      // ==========================================
      ShellRoute(
        navigatorKey: _aggregatorShellNavigatorKey,
        builder: (context, state, child) => AggregatorShell(child: child),
        routes: [
          GoRoute(
            path: '/aggregator/home',
            builder: (context, state) => const aggregator.AggregatorHomeScreen(),
          ),
          GoRoute(
            path: '/aggregator/artisans',
            builder: (context, state) => const AggregatorArtisansListScreen(),
          ),
          GoRoute(
            path: '/aggregator/analytics',
            builder: (context, state) => const ClusterAnalyticsScreen(),
          ),
          GoRoute(
            path: '/aggregator/alerts',
            builder: (context, state) => const AlertsReportingScreen(),
          ),
        ],
      ),

      // ==========================================
      // BUYER MODULE
      // ==========================================
      ShellRoute(
        navigatorKey: _buyerShellNavigatorKey,
        builder: (context, state, child) => BuyerShell(child: child),
        routes: [
          GoRoute(
            path: '/buyer/home',
            builder: (context, state) => const buyer.BuyerHomeScreen(),
          ),
          GoRoute(
            path: '/buyer/inquiries',
            builder: (context, state) => const MyInquiriesScreen(),
          ),
          GoRoute(
            path: '/buyer/profile',
            builder: (context, state) => const BuyerProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/buyer/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: id);
        },
      ),
    ],
  );
});
