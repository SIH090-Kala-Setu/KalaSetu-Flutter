import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class BuyerProfileScreen extends ConsumerWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider.notifier).currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enterprise Buyer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.push('/onboarding/language'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Enterprise Header Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.business, size: 36, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'FabCraft Retail Ltd',
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.verified, color: AppColors.success, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'MoSJE Verified B2B Buyer',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Retailer / Exporter · New Delhi, India',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Procurement Metrics Card
          AppCard(
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Procurement Statistics',
                  style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('2', 'Sent Inquiries'),
                    _buildStat('75', 'Units Ordered'),
                    _buildStat('4', 'Matched Clusters'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Logout',
            variant: AppButtonVariant.danger,
            icon: Icons.logout,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading.copyWith(
            color: AppColors.accent,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

