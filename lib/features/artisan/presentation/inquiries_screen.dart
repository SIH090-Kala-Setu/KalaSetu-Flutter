import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/empty_state.dart';

class InquiriesScreen extends ConsumerStatefulWidget {
  const InquiriesScreen({super.key});

  @override
  ConsumerState<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends ConsumerState<InquiriesScreen> {
  bool _isLoading = true;
  List<InquiryModel> _inquiries = [];

  @override
  void initState() {
    super.initState();
    _fetchInquiries();
  }

  void _fetchInquiries() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getInquiries();
      if (mounted) {
        setState(() {
          _inquiries = list;
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

  void _openInquiryThread(InquiryModel inquiry) {
    final replyController = TextEditingController();

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
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inquiry.buyerName,
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                  StatusBadge(status: inquiry.status),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  inquiry.message ?? 'Inquiry details',
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Requested Quantity: ${inquiry.quantity} units · Contact: ${inquiry.buyerEmail}',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: replyController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Type your quotation or reply...',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Accept & Quote',
                      onPressed: () async {
                        final apiClient = ref.read(apiClientProvider);
                        await apiClient.respondToInquiry(
                          inquiry.id,
                          replyController.text.trim().isNotEmpty
                              ? replyController.text.trim()
                              : 'We accept your request.',
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _fetchInquiries();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Mark Completed',
                      variant: AppButtonVariant.outlined,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.inquiries)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _inquiries.isEmpty
          ? EmptyStateWidget(
              title: 'No Inquiries Yet',
              message:
                  'When B2B wholesale buyers request quotes for your products, they will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _inquiries.length,
              itemBuilder: (context, index) {
                final inq = _inquiries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AppCard(
                    onTap: () => _openInquiryThread(inq),
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
                                fontSize: 16,
                              ),
                            ),
                            StatusBadge(status: inq.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          inq.message ?? '',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${inq.quantity} units requested',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              inq.createdAt ?? 'Recent',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 12,
                              ),
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
