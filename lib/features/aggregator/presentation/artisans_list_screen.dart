import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';

class AggregatorArtisansListScreen extends ConsumerStatefulWidget {
  const AggregatorArtisansListScreen({super.key});

  @override
  ConsumerState<AggregatorArtisansListScreen> createState() =>
      _AggregatorArtisansListScreenState();
}

class _AggregatorArtisansListScreenState
    extends ConsumerState<AggregatorArtisansListScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = true;
  bool _hasError = false;
  List<UserModel> _artisans = [];
  final _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Verified', 'Pending', 'Needs Help'];

  @override
  void initState() {
    super.initState();
    _fetchArtisans();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchArtisans() async {
    setState(() { _isLoading = true; _hasError = false; });
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getAggregatorArtisans();
      if (mounted) setState(() { _artisans = list; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  List<UserModel> get _filteredArtisans {
    final query = _searchController.text.trim().toLowerCase();
    return _artisans.where((a) {
      final matchesSearch =
          a.fullName.toLowerCase().contains(query) ||
          (a.phoneNumber?.contains(query) ?? false);
      if (!matchesSearch) return false;

      if (_selectedFilter == 'Verified') return a.isVerified;
      if (_selectedFilter == 'Pending') return !a.isVerified;
      if (_selectedFilter == 'Needs Help') return !a.isVerified;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cluster Artisans Roster'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchArtisans),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by artisan name or phone...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedFilter = filter);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Artisans List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off, size: 48, color: AppColors.textDisabled),
                            const SizedBox(height: 12),
                            const Text('Could not load artisans.', style: TextStyle(color: AppColors.textSecondary)),
                            const SizedBox(height: 12),
                            TextButton.icon(onPressed: _fetchArtisans, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                          ],
                        ),
                      )
                    : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredArtisans.length,
                    itemBuilder: (context, index) {
                      final artisan = _filteredArtisans[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AppCard(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
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
                                    Row(
                                      children: [
                                        Text(
                                          artisan.fullName,
                                          style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        StatusBadge(
                                          status: artisan.isVerified
                                              ? 'Verified'
                                              : 'Pending',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${artisan.district}, ${artisan.state} · ${artisan.phoneNumber ?? 'No phone'}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              AppButton(
                                label: 'Assist',
                                width: 80,
                                height: 38,
                                onPressed: () {
                                  context.push('/artisan/studio');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
