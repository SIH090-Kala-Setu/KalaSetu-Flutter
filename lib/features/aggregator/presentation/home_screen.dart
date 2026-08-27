import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';

class AggregatorHomeScreen extends ConsumerStatefulWidget {
  const AggregatorHomeScreen({super.key});

  @override
  ConsumerState<AggregatorHomeScreen> createState() =>
      _AggregatorHomeScreenState();
}

class _AggregatorHomeScreenState extends ConsumerState<AggregatorHomeScreen> {
  bool _isLoading = true;
  int _totalArtisans = 48;
  int _activeListings = 112;
  final int _pendingVerifications = 8;
  int _inquiriesThisMonth = 34;

  List<UserModel> _unlistedArtisans = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  void _fetchDashboard() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.getAggregatorDashboard();
      if (mounted) {
        setState(() {
          _totalArtisans = data['total_artisans'] ?? 48;
          _activeListings = data['total_active_listings'] ?? 112;
          _inquiriesThisMonth = data['total_pending_inquiries'] ?? 34;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _unlistedArtisans = [
            UserModel(
              id: 'a1',
              username: 'ganesh_weaver',
              fullName: 'Ganesh Devangan',
              phoneNumber: '9876543211',
              role: 'Artisan',
              state: 'Gujarat',
              district: 'Patan',
              isVerified: true,
            ),
            UserModel(
              id: 'a2',
              username: 'savita_potter',
              fullName: 'Savita Ben',
              phoneNumber: '9876543212',
              role: 'Artisan',
              state: 'Gujarat',
              district: 'Kutch',
              isVerified: false,
            ),
          ];
          _isLoading = false;
        });
      }
    }
  }

  void _showOnboardSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String craftType = 'Textiles & Handloom';

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
              Text(
                'Assisted Artisan Onboarding',
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Register low-literacy artisans in the field and initiate fast-track MoSJE verification.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Artisan Full Name',
                  hintText: 'e.g. Laxman Weaver',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+91 ',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: craftType,
                decoration: const InputDecoration(
                  labelText: 'Craft Specialization',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Textiles & Handloom',
                    child: Text('Textiles & Handloom'),
                  ),
                  DropdownMenuItem(
                    value: 'Clay & Pottery',
                    child: Text('Clay & Pottery'),
                  ),
                  DropdownMenuItem(
                    value: 'Jewelry & Silver',
                    child: Text('Jewelry & Silver'),
                  ),
                  DropdownMenuItem(
                    value: 'Woodwork & Inlay',
                    child: Text('Woodwork & Inlay'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) craftType = v;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Submit for MoSJE Onboarding',
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    return;
                  }
                  final apiClient = ref.read(apiClientProvider);
                  await apiClient.onboardArtisan(
                    fullName: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    craftType: craftType,
                    clusterName: 'Patan Patola Handloom Cluster',
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.success,
                      content: Text(
                        'Artisan onboarded and added to cluster queue!',
                      ),
                    ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cluster Governance Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Assisted Onboarding',
            onPressed: _showOnboardSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cluster Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patan Patola Cluster',
                              style: AppTextStyles.display.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'MoSJE Mandated',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Gujarat · Silk & Ikat Specialization · 48 Active Artisans',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Horizontal Scroll Summary Cards
                  Text(
                    'Cluster Health Metrics',
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSummaryCard(
                          'Total Artisans',
                          '$_totalArtisans',
                          Icons.group,
                          AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryCard(
                          'Active Listings',
                          '$_activeListings',
                          Icons.inventory_2,
                          AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryCard(
                          'Pending KYC',
                          '$_pendingVerifications',
                          Icons.hourglass_empty,
                          const Color(0xFFD68910),
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryCard(
                          'Inquiries (30d)',
                          '$_inquiriesThisMonth',
                          Icons.chat,
                          AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Assisted Onboarding Action Banner
                  AppCard(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    border: Border.all(color: AppColors.accent),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.accent,
                          child: Icon(Icons.person_add, color: Colors.black87),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assisted Onboarding',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Help low-literacy artisans register with voice in 2 mins',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showOnboardSheet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            minimumSize: const Size(60, 40),
                          ),
                          child: const Text(
                            'Start',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Artisans Needing Support Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Artisans Needing Help',
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '0 Listings (Unlisted)',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._unlistedArtisans.map(
                    (artisan) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    artisan.fullName,
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${artisan.district}, ${artisan.state} · 0 products',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              label: 'Assist Studio',
                              width: 120,
                              height: 42,
                              onPressed: () {
                                context.push('/artisan/studio');
                              },
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

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.heading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
