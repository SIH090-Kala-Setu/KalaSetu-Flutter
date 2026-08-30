import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_card.dart';

class ClusterAnalyticsScreen extends ConsumerStatefulWidget {
  const ClusterAnalyticsScreen({super.key});

  @override
  ConsumerState<ClusterAnalyticsScreen> createState() => _ClusterAnalyticsScreenState();
}

class _ClusterAnalyticsScreenState extends ConsumerState<ClusterAnalyticsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() { _isLoading = true; _hasError = false; });
    try {
      final data = await ref.read(apiClientProvider).getAggregatorDashboard();
      if (mounted) setState(() { _data = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cluster Analytics & Trends'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetch),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 48, color: AppColors.textDisabled),
                      const SizedBox(height: 12),
                      const Text('Could not load analytics.', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      TextButton.icon(onPressed: _fetch, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final clusters = (_data?['clusters'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final totalArtisans = _data?['total_artisans'] ?? 0;
    final totalListings = _data?['total_active_listings'] ?? 0;
    final totalClusters = _data?['total_clusters'] ?? 0;

    // Aggregate craft type counts across all clusters
    final Map<String, int> craftCounts = {};
    int totalWithListings = 0;
    int totalNeedingSupport = 0;
    final List<Map<String, dynamic>> topArtisans = [];

    for (final cluster in clusters) {
      totalWithListings += (cluster['artisans_with_listings'] as int? ?? 0);
      totalNeedingSupport += (cluster['artisans_needing_support'] as int? ?? 0);
      final artisans = (cluster['artisans'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
      for (final a in artisans) {
        final craft = a['craft_type']?.toString() ?? 'Other';
        craftCounts[craft] = (craftCounts[craft] ?? 0) + 1;
        if ((a['listing_count'] as int? ?? 0) > 0) {
          topArtisans.add(a);
        }
      }
    }

    // Sort craft counts descending
    final sortedCrafts = craftCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCraft = sortedCrafts.isNotEmpty ? sortedCrafts.first.value : 1;

    // Sort top artisans by listing count
    topArtisans.sort((a, b) => (b['listing_count'] as int? ?? 0).compareTo(a['listing_count'] as int? ?? 0));

    final colors = [AppColors.primary, AppColors.accent, const Color(0xFF1ABC9C), const Color(0xFFE67E22)];

    return RefreshIndicator(
      onRefresh: () async => _fetch(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Summary row
          Row(
            children: [
              _statChip('$totalClusters', 'Clusters', AppColors.primary),
              const SizedBox(width: 10),
              _statChip('$totalArtisans', 'Artisans', AppColors.success),
              const SizedBox(width: 10),
              _statChip('$totalListings', 'Active Listings', AppColors.accent),
            ],
          ),
          const SizedBox(height: 20),
          // Craft distribution
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Artisans by Craft Specialization', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                const SizedBox(height: 16),
                if (sortedCrafts.isEmpty)
                  Text('No craft data available.', style: AppTextStyles.caption)
                else
                  ...sortedCrafts.take(6).toList().asMap().entries.map((e) {
                    final color = colors[e.key % colors.length];
                    return _buildCraftBar(e.value.key, e.value.value, e.value.value / maxCraft, color);
                  }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Top artisans by listings
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Artisans by Active Listings', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                const SizedBox(height: 12),
                if (topArtisans.isEmpty)
                  Text('No active listings yet.', style: AppTextStyles.caption)
                else
                  ...topArtisans.take(5).toList().asMap().entries.map((e) {
                    final a = e.value;
                    return _buildTopArtisanTile(
                      '${e.key + 1}',
                      a['name']?.toString() ?? 'Artisan',
                      '${a['listing_count']} Listings',
                      a['craft_type']?.toString() ?? '',
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Cluster health summary
          AppCard(
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cluster Health Summary', style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  '• $totalWithListings of $totalArtisans artisans have active listings\n'
                  '• $totalNeedingSupport artisans need cataloguing support\n'
                  '• $totalClusters cluster(s) under management',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 13, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.heading.copyWith(fontSize: 20, color: color)),
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftBar(String name, int count, double fraction, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(name, style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
              Text('$count artisans', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: fraction,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildTopArtisanTile(String rank, String name, String listings, String craft) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('$listings · $craft', style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
