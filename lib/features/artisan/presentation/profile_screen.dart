import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showBankEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Update Bank & Direct Payout Details', style: AppTextStyles.heading.copyWith(fontSize: 18)),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(labelText: 'Bank Account Number', hintText: '1029384756'),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'IFSC Code', hintText: 'SBIN0000001'),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'UPI ID', hintText: 'name@upi'),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Save Payout Details',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bank details updated successfully')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider.notifier).currentUser;
    final artisanName = user?.fullName ?? 'Ramesh Chandra';
    final isVerified = user?.isVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.roleArtisan),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              context.push('/onboarding/language');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Profile Header Card
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 44, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artisanName,
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isVerified ? Icons.verified : Icons.hourglass_top,
                            color: isVerified ? AppColors.success : const Color(0xFFD68910),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isVerified ? 'MoSJE Verified' : 'KYC Pending Review',
                            style: AppTextStyles.caption.copyWith(
                              color: isVerified ? AppColors.success : const Color(0xFFD68910),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Varanasi Silk Weaver Cluster · Uttar Pradesh',
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Craft Specialization Chips
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.craftType, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      avatar: const Text('🧵'),
                      label: const Text('Textiles & Handloom'),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    Chip(
                      avatar: const Text('🏺'),
                      label: const Text('Clay & Pottery'),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Analytics Summary Card
          AppCard(
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Performance Overview',
                      style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: AppColors.accent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading CSV Sales Report...')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('12', 'Listings'),
                    _buildStat('184', 'Views'),
                    _buildStat('18', 'Inquiries'),
                    _buildStat('₹24.5k', 'Earnings'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Bank / UPI Details
          AppCard(
            onTap: () => _showBankEditSheet(context),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: AppColors.primary, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Direct Bank & UPI Settlement', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('A/C: •••• 4756 · IFSC: SBIN0000001 · ram@upi', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textDisabled),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Exhibition Registrations
          AppCard(
            onTap: () => context.push('/artisan/exhibitions'),
            child: Row(
              children: [
                const Icon(Icons.event_seat, color: AppColors.primary, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exhibition Registrations', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('2 Confirmed Fairs (Shilp Samagam, Dilli Haat)', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textDisabled),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Logout CTA
          AppButton(
            label: l10n.logout,
            variant: AppButtonVariant.danger,
            icon: Icons.logout,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 16),
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
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
