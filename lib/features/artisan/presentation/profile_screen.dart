import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final data = await apiClient.getArtisanProfile();
      if (mounted) {
        setState(() {
          _profileData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showBankEditSheet(BuildContext context) {
    final bankCtrl = TextEditingController(text: _profileData?['bank_account']?.toString() ?? '');
    final ifscCtrl = TextEditingController(text: _profileData?['ifsc_code']?.toString() ?? '');
    final upiCtrl = TextEditingController(text: _profileData?['upi_id']?.toString() ?? '');
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
                  TextField(
                    controller: bankCtrl,
                    decoration: const InputDecoration(labelText: 'Bank Account Number', hintText: '1029384756'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ifscCtrl,
                    decoration: const InputDecoration(labelText: 'IFSC Code', hintText: 'SBIN0000001'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: upiCtrl,
                    decoration: const InputDecoration(labelText: 'UPI ID', hintText: 'name@upi'),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Save Payout Details',
                    isLoading: isSaving,
                    onPressed: () async {
                      setSheetState(() => isSaving = true);
                      try {
                        final apiClient = ref.read(apiClientProvider);
                        await apiClient.updateArtisanProfile({
                          'bank_account': bankCtrl.text.trim(),
                          'ifsc_code': ifscCtrl.text.trim(),
                          'upi_id': upiCtrl.text.trim(),
                        });
                        _fetchProfile();
                      } catch (_) {}
                      if (!context.mounted) return;
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
      },
    );
  }

  void _showProfileEditSheet(BuildContext context) {
    final crafts = [
      'Weaving', 'Pottery', 'Embroidery', 'Woodwork', 'Metalwork',
      'Painting', 'Jewelry', 'Leather', 'Stone Carving', 'Bamboo',
      'Handloom', 'Block Printing', 'Other Handicrafts',
    ];
    final languages = ['hi', 'en', 'ta', 'te', 'mr', 'bn', 'gu', 'kn', 'or', 'pa'];
    final langNames = {
      'hi': 'Hindi', 'en': 'English', 'ta': 'Tamil', 'te': 'Telugu',
      'mr': 'Marathi', 'bn': 'Bengali', 'gu': 'Gujarati', 'kn': 'Kannada',
      'or': 'Odia', 'pa': 'Punjabi',
    };

    final nameCtrl = TextEditingController(text: _profileData?['full_name']?.toString() ?? '');
    final districtCtrl = TextEditingController(text: _profileData?['cluster_name']?.toString() ?? '');
    final aadhaarCtrl = TextEditingController(text: _profileData?['aadhaar_number']?.toString() ?? '');
    String selectedCraft = _profileData?['craft_type']?.toString() ?? crafts.first;
    String selectedLang = _profileData?['preferred_language']?.toString() ?? 'hi';
    if (!crafts.contains(selectedCraft)) selectedCraft = crafts.first;
    if (!languages.contains(selectedLang)) selectedLang = 'hi';
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Edit Profile', style: AppTextStyles.heading.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Your full name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCraft,
                      decoration: const InputDecoration(labelText: 'Craft Type'),
                      items: crafts.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setSheetState(() => selectedCraft = v ?? selectedCraft),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: districtCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Cluster / District',
                        hintText: 'e.g. Varanasi Cluster',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: aadhaarCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Aadhaar Number',
                        hintText: '12-digit Aadhaar number',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedLang,
                      decoration: const InputDecoration(labelText: 'Preferred Language'),
                      items: languages.map((l) => DropdownMenuItem(
                        value: l,
                        child: Text(langNames[l] ?? l),
                      )).toList(),
                      onChanged: (v) => setSheetState(() => selectedLang = v ?? selectedLang),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Save Profile',
                      isLoading: isSaving,
                      onPressed: () async {
                        setSheetState(() => isSaving = true);
                        try {
                          final apiClient = ref.read(apiClientProvider);
                          await apiClient.updateArtisanProfile({
                            'full_name': nameCtrl.text.trim(),
                            'craft_type': selectedCraft,
                            'cluster_name': districtCtrl.text.trim(),
                            'preferred_language': selectedLang,
                            if (aadhaarCtrl.text.trim().isNotEmpty)
                              'aadhaar_number': aadhaarCtrl.text.trim(),
                          });
                          _fetchProfile();
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
              ),
            );
          },
        );
      },
    );
  }

  void _downloadReport() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final csv = await apiClient.getArtisanReport();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('CSV Sales & Analytics Report'),
            content: SingleChildScrollView(
              child: Text(
                csv.isNotEmpty ? csv : 'No sales records found.',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate sales report.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider.notifier).currentUser;
    final rawName = _profileData?['full_name'] ?? user?.fullName ?? '';
    final isPhone = rawName.isEmpty || RegExp(r'^\+?\d[\d\s\-()]{6,}$').hasMatch(rawName.trim());
    final artisanName = isPhone ? 'Master Artisan' : rawName;
    final isVerified = _profileData?['is_verified'] ?? user?.isVerified ?? false;
    final craftType = _profileData?['craft_type'] ?? 'Handicrafts';
    final clusterName = _profileData?['cluster_name'] ?? (_profileData?['cluster']?['name']) ?? 'Varanasi Cluster';

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Profile Header Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  onTap: () => _showProfileEditSheet(context),
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
                            const SizedBox(height: 2),
                            Text(craftType, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Cluster & Gov Scheme Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Assigned Cluster',
                            style: AppTextStyles.caption.copyWith(color: Colors.white70),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'DBT Eligible',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clusterName,
                        style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Bank Details Card
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
                            Text(
                              _profileData?['bank_account'] != null
                                  ? 'A/C: ${_profileData!['bank_account']} · IFSC: ${_profileData?['ifsc_code'] ?? 'N/A'}'
                                  : 'Tap to configure Bank & UPI payouts',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textDisabled),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // CSV Report Download Card
                AppCard(
                  onTap: _downloadReport,
                  child: Row(
                    children: [
                      const Icon(Icons.file_download_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Download Sales & Performance CSV Report', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text('Export product analytics and buyer inquiry records', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textDisabled),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                            Text('Discover Shilp Samagam, Surajkund & Dilli Haat', style: AppTextStyles.caption),
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
}
