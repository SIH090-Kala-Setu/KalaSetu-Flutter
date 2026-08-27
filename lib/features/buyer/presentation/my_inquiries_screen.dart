import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';

class MyInquiriesScreen extends ConsumerStatefulWidget {
  const MyInquiriesScreen({super.key});

  @override
  ConsumerState<MyInquiriesScreen> createState() => _MyInquiriesScreenState();
}

class _MyInquiriesScreenState extends ConsumerState<MyInquiriesScreen> {
  bool _isLoading = true;
  List<InquiryModel> _inquiries = [];

  @override
  void initState() {
    super.initState();
    _fetchBuyerInquiries();
  }

  void _fetchBuyerInquiries() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final dashboard = await apiClient.getBuyerDashboard();
      final history = (dashboard['inquiry_history'] as List<dynamic>?) ?? [];
      if (mounted) {
        setState(() {
          _inquiries = history
              .map((json) => InquiryModel.fromJson(json))
              .toList();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Sent Wholesale Inquiries')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _inquiries.length,
              itemBuilder: (context, index) {
                final inq = _inquiries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${inq.id.substring(0, inq.id.length > 8 ? 8 : inq.id.length)}',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StatusBadge(status: inq.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          inq.message ?? 'Wholesale bulk order request',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Requested: ${inq.quantity} units',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              inq.createdAt ?? 'Recent',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
