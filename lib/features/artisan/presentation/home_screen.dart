import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/models/scheme_model.dart';
import '../../auth/providers/auth_provider.dart';

class ArtisanHomeScreen extends ConsumerStatefulWidget {
  const ArtisanHomeScreen({super.key});

  @override
  ConsumerState<ArtisanHomeScreen> createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends ConsumerState<ArtisanHomeScreen> {
  bool _isLoading = true;
  int _activeListings = 12;
  int _pendingInquiries = 3;
  int _totalViews = 184;
  double _estIncome = 24500.0;
  List<InquiryModel> _recentInquiries = [];
  List<GovtSchemeModel> _schemes = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.getArtisanDashboard();
      final inqs = await apiClient.getInquiries();

      // Fetch profile to get the live is_verified status from the backend
      // (local cache from login time always starts as false)
      try {
        final profile = await apiClient.getArtisanProfile();
        final isVerified = profile['is_verified'] == true;
        await ref.read(authProvider.notifier).refreshUserVerification(isVerified);
      } catch (_) {}

      List<GovtSchemeModel> schemes = [];
      try {
        schemes = await apiClient.getSchemes();
        schemes = schemes.where((s) => s.isActive).toList();
      } catch (_) {}

      if (mounted) {
        setState(() {
          _activeListings = data['active_listings'] ?? 0;
          _pendingInquiries = data['pending_inquiries'] ?? 0;
          _totalViews = data['total_views'] ?? 0;
          _estIncome = (data['revenue_estimate'] ?? 0.0).toDouble();
          _recentInquiries = inqs.take(3).toList();
          _schemes = schemes;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider.notifier).currentUser;
    final rawName = user?.fullName ?? '';
    final isPhone = rawName.isEmpty || RegExp(r'^\+?\d[\d\s\-()]{6,}$').hasMatch(rawName.trim());
    final artisanName = isPhone ? 'Master Artisan' : rawName;
    final isVerified = user?.isVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.palette, size: 20, color: Colors.black87),
            ),
            const SizedBox(width: 10),
            Text(
              'कलाSetu',
              style: AppTextStyles.heading.copyWith(fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 26),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 24),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Greeting
                  Text(
                    '${l10n.namaste}, $artisanName 🙏',
                    style: AppTextStyles.display.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 12),
                  // Verification Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isVerified
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isVerified
                            ? AppColors.success
                            : const Color(0xFFD68910),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.hourglass_top,
                          color: isVerified
                              ? AppColors.success
                              : const Color(0xFFD68910),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isVerified
                                ? l10n.verifiedArtisan
                                : l10n.verificationPending,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isVerified
                                  ? AppColors.success
                                  : const Color(0xFFB9770E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Total Earnings Card
                  AppCard(
                    color: AppColors.primary,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.estIncome,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'This Month',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹ ${_estIncome.toStringAsFixed(0)}',
                          style: AppTextStyles.display.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '$_activeListings Active Products',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$_totalViews Catalog Views',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 2x2 Quick Action Grid
                  Text(
                    l10n.quickActions,
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      _buildQuickActionTile(
                        icon: Icons.camera_alt,
                        label: l10n.addProduct,
                        color: AppColors.accent,
                        iconColor: Colors.black87,
                        onTap: () {
                          context.push('/artisan/studio');
                        },
                      ),
                      _buildQuickActionTile(
                        icon: Icons.grid_view_rounded,
                        label: l10n.myCatalogue,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        iconColor: AppColors.primary,
                        onTap: () {
                          context.go('/artisan/catalog');
                        },
                      ),
                      _buildQuickActionTile(
                        icon: Icons.chat_bubble_outline,
                        label: l10n.inquiries,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        iconColor: AppColors.primary,
                        badge: '$_pendingInquiries',
                        onTap: () {
                          context.go('/artisan/inquiries');
                        },
                      ),
                      _buildQuickActionTile(
                        icon: Icons.event_available,
                        label: l10n.exhibitions,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        iconColor: AppColors.primary,
                        onTap: () {
                          context.push('/artisan/exhibitions');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Govt Schemes Section
                  if (_schemes.isNotEmpty) ...[  
                    Text(
                      'Government Schemes',
                      style: AppTextStyles.heading.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ..._schemes.map((scheme) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.campaign, color: AppColors.accent, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scheme.schemeName,
                                    style: AppTextStyles.body.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    scheme.description,
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (scheme.validUntil != null) ...[  
                                    const SizedBox(height: 4),
                                    Text(
                                      'Valid until: ${scheme.validUntil}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.accent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                  const SizedBox(height: 24),
                  // Recent Inquiries Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recentInquiries,
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/artisan/inquiries');
                        },
                        child: Text(
                          l10n.viewAll,
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._recentInquiries.map(
                    (inq) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppCard(
                        onTap: () {
                          context.go('/artisan/inquiries');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  inq.buyerName,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                StatusBadge(status: inq.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              inq.message ?? 'Bulk order inquiry',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantity: ${inq.quantity} units',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  inq.createdAt ?? 'Recent',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: iconColor == Colors.black87
                        ? Colors.black87
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
