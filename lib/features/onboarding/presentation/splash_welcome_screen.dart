import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';

class SplashWelcomeScreen extends StatelessWidget {
  const SplashWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              // App Logo & Emblem
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.palette,
                      size: 48,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                l10n.welcomeTitle,
                style: AppTextStyles.display.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Tagline
              Text(
                l10n.welcomeSub,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Illustration card representing handloom & crafts
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.background,
                      child: Text('🎨', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appTagline,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MoSJE · SIH26090',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              // Register CTA
              AppButton(
                label: l10n.iAmNewHere,
                onPressed: () {
                  context.push('/onboarding/role');
                },
              ),
              const SizedBox(height: 12),
              // Login CTA
              AppButton(
                label: l10n.iHaveAccount,
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  context.push('/login');
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

