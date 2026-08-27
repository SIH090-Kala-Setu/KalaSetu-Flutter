import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading/initialization time
    Future.delayed(const Duration(seconds: 2), () {
      // The GoRouter redirect logic in app_router will handle where to go from here
      // once auth state is initialized. If auth state is already determined, we can
      // just push to the auth router. For now, since GoRouter handles initial auth
      // redirects, if it's still here after 2s, we manually trigger the router.
      if (mounted) {
        context.go('/onboarding/language');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using a simple text logo for now
            Text(
              'कलाSetu',
              style: AppTextStyles.display.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
