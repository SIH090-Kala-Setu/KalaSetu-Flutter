import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class BuyerProfileScreen extends ConsumerStatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  ConsumerState<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends ConsumerState<BuyerProfileScreen> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.getBuyerDashboard();
      if (mounted) setState(() { _dashboardData = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showEditSheet(BuildContext context) {
    final user = ref.read(authProvider.notifier).currentUser;
    final nameCtrl = TextEditingController(text: _dashboardData?['buyer_name']?.toString() ?? user?.fullName ?? '');
    final stateCtrl = TextEditingController(text: user?.state ?? '');
    final districtCtrl = TextEditingController(text: user?.district ?? '');
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Edit Profile', style: AppTextStyles.heading.copyWith(fontSize: 18)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full Name / Company Name', hintText: 'e.g. FabCraft Retail Ltd'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: stateCtrl,
                    decoration: const InputDecoration(labelText: 'State', hintText: 'e.g. Delhi'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: districtCtrl,
                    decoration: const InputDecoration(labelText: 'District', hintText: 'e.g. New Delhi'),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Save',
                    isLoading: isSaving,
                    onPressed: () async {
                      setSheetState(() => isSaving = true);
                      try {
                        final apiClient = ref.read(apiClientProvider);
                        await apiClient.updateArtisanProfile({
                          'full_name': nameCtrl.text.trim(),
                          'state': stateCtrl.text.trim(),
                          'district': districtCtrl.text.trim(),
                        });
                        _fetchData();
                      } catch (_) {}
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully ✓')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider.notifier).currentUser;
    final buyerName = _dashboardData?['buyer_name'] ?? user?.fullName ?? 'B2B Buyer';
    final isVerified = user?.isVerified ?? false;
    final totalInquiries = _dashboardData?['total_inquiries'] ?? 0;
    final pendingInquiries = _dashboardData?['pending_inquiries'] ?? 0;
    final completedInquiries = _dashboardData?['completed_inquiries'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Enterprise Buyer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.push('/onboarding/language'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile Header Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  onTap: () => _showEditSheet(context),
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
                            Text(buyerName, style: AppTextStyles.heading.copyWith(fontSize: 18)),
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
                                  isVerified ? 'MoSJE Verified B2B Buyer' : 'Verification Pending',
                                  style: AppTextStyles.caption.copyWith(
                                    color: isVerified ? AppColors.success : const Color(0xFFD68910),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${user?.district ?? ''} ${user?.state ?? ''}'.trim().isEmpty
                                  ? 'Tap to update location'
                                  : '${user?.district ?? ''}, ${user?.state ?? ''}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit_outlined, color: AppColors.textDisabled, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Procurement Stats Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                          _buildStat('$totalInquiries', 'Total Inquiries'),
                          _buildStat('$pendingInquiries', 'Pending'),
                          _buildStat('$completedInquiries', 'Completed'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Notifications Card
                AppCard(
                  onTap: () => context.push('/notifications'),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Notifications & Alerts', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textDisabled),
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
        Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
