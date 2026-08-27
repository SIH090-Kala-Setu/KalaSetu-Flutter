import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isHindi = false;
  int _quantity = 25;
  bool _isSubmitting = false;

  void _showInquirySheet() {
    final messageController = TextEditingController(
      text: 'I am interested in procuring $_quantity units for our retail chain. Please share wholesale lead time and custom packaging options.',
    );

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
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Submit B2B Bulk Inquiry', style: AppTextStyles.heading.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Direct message to verified artisan cooperative.', style: AppTextStyles.caption),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity (Units):', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (_quantity > 5) {
                                setSheetState(() => _quantity -= 5);
                              }
                            },
                          ),
                          Text('$_quantity', style: AppTextStyles.heading),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setSheetState(() => _quantity += 5);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Inquiry Message'),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Send Formal RFQ / Inquiry',
                    isLoading: _isSubmitting,
                    onPressed: () async {
                      setSheetState(() => _isSubmitting = true);
                      final apiClient = ref.read(apiClientProvider);
                      await apiClient.createInquiry(
                        productId: widget.productId,
                        buyerName: 'FabCraft Procurement',
                        buyerEmail: 'procurement@fabcraft.com',
                        quantity: _quantity,
                        notes: messageController.text.trim(),
                      );
                      setSheetState(() => _isSubmitting = false);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.success,
                          content: Text('✅ Bulk inquiry submitted! The artisan has been notified.'),
                        ),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Product Details'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isHindi = !_isHindi),
            child: Text(
              _isHindi ? 'English' : 'हिंदी',
              style: AppTextStyles.button.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          label: 'Send Bulk Order Inquiry',
          icon: Icons.send,
          onPressed: _showInquirySheet,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Width Product Image Box
            Container(
              height: 300,
              color: AppColors.primary.withValues(alpha: 0.08),
              child: const Center(
                child: Icon(Icons.shopping_bag_outlined, size: 100, color: AppColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _isHindi ? 'हथकरघा बनारसी कातन सिल्क साड़ी' : 'Handwoven Banarasi Katan Silk Saree',
                    style: AppTextStyles.display.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  // Price Comparison Row
                  Row(
                    children: [
                      Text(
                        '₹ 4,200',
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹ 5,800 (Retail)',
                        style: AppTextStyles.caption.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '28% B2B Margin',
                          style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: const [
                      Chip(label: Text('Pure Silk', style: TextStyle(fontSize: 12))),
                      Chip(label: Text('Zari Brocade', style: TextStyle(fontSize: 12))),
                      Chip(label: Text('Varanasi GI Tagged', style: TextStyle(fontSize: 12))),
                      Chip(label: Text('MoSJE Certified', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    _isHindi ? 'विवरण' : 'Story & Description',
                    style: AppTextStyles.heading.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isHindi
                        ? 'यह बनारसी कातन साड़ी वाराणसी के पारंपरिक बुनकरों द्वारा शुद्ध शहतूत रेशम और सोने की ज़री से तैयार की गई है।'
                        : 'Authentic pure mulberry silk handwoven Banarasi saree with intricate gold zari brocade motifs woven on traditional wooden pit looms.',
                    style: AppTextStyles.body.copyWith(height: 1.5, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  // Master Artisan Card
                  Text('Artisan & Cluster Credentials', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Ramesh Chandra Weaver',
                                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, color: AppColors.success, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text('Varanasi Silk Weaver Cooperative', style: AppTextStyles.caption),
                              Text('MoSJE Beneficiary · 28 Yrs Experience', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
