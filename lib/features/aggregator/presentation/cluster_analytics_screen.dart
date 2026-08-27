import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class ClusterAnalyticsScreen extends StatelessWidget {
  const ClusterAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cluster Analytics & Trends')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Craft Type Distribution Card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Listings by Craft Specialization',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildCraftBar(
                  'Double Ikat Patola Silk',
                  45,
                  0.65,
                  AppColors.primary,
                ),
                _buildCraftBar(
                  'Single Ikat Handloom',
                  28,
                  0.40,
                  AppColors.accent,
                ),
                _buildCraftBar(
                  'Bandhani & Natural Dye',
                  18,
                  0.25,
                  const Color(0xFF1ABC9C),
                ),
                _buildCraftBar(
                  'Embroidered Stoles',
                  12,
                  0.18,
                  const Color(0xFFE67E22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Top 5 Products by Bulk Inquiry Volume
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Products by Inquiry Volume',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildTopProductTile(
                  '1',
                  'Patan Double Ikat Heritage Saree',
                  '34 Inquiries',
                  '₹ 18,500',
                ),
                _buildTopProductTile(
                  '2',
                  'Pure Silk Handloom Dupatta',
                  '22 Inquiries',
                  '₹ 3,400',
                ),
                _buildTopProductTile(
                  '3',
                  'Traditional Zari Border Stole',
                  '18 Inquiries',
                  '₹ 1,800',
                ),
                _buildTopProductTile(
                  '4',
                  'Ikat Wall Tapestry Panel',
                  '11 Inquiries',
                  '₹ 4,200',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 30-day Trend Card
          AppCard(
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-Day Cluster Growth',
                  style: AppTextStyles.heading.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• +14 New Artisans Digitized\n'
                  '• +42 Active Products Listed\n'
                  '• ₹ 4,20,000 Estimated B2B Wholesale Pipeline',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              Text(
                name,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$count items',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  Widget _buildTopProductTile(
    String rank,
    String title,
    String inq,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              rank,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '$inq · $price',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
