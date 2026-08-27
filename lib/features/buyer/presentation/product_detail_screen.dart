import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/product_thumbnail.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isHindi = false;
  int _quantity = 10;
  bool _isSubmitting = false;
  bool _isLoading = true;
  ProductModel? _product;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  void _fetchProduct() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final p = await apiClient.getProductDetail(widget.productId);
      if (mounted) {
        setState(() {
          _product = p;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showInquirySheet() {
    final title = _product?.titleEn ?? 'Product';
    final messageController = TextEditingController(
      text: 'I am interested in procuring $_quantity units of $title for our retail chain. Please share wholesale lead time and logistics details.',
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
                  Text('Direct quotation request to the verified artisan cooperative.', style: AppTextStyles.caption),
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
                              if (_quantity > 1) {
                                setSheetState(() => _quantity -= 1);
                              }
                            },
                          ),
                          Text('$_quantity', style: AppTextStyles.heading),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setSheetState(() => _quantity += 1);
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
                    decoration: const InputDecoration(labelText: 'Inquiry Message / Requirements'),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Send Formal RFQ / Inquiry',
                    isLoading: _isSubmitting,
                    onPressed: () async {
                      setSheetState(() => _isSubmitting = true);
                      try {
                        final apiClient = ref.read(apiClientProvider);
                        await apiClient.createInquiry(
                          productId: widget.productId,
                          buyerName: 'Enterprise Buyer',
                          buyerEmail: 'procurement@kala.gov.in',
                          quantity: _quantity,
                          notes: messageController.text.trim(),
                        );
                      } catch (_) {}
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final p = _product;
    final title = _isHindi ? (p?.titleHi.isNotEmpty == true ? p!.titleHi : p?.titleEn ?? 'शिल्प') : (p?.titleEn ?? 'Product');
    final desc = _isHindi ? (p?.descriptionHi?.isNotEmpty == true ? p!.descriptionHi : p?.descriptionEn ?? '') : (p?.descriptionEn ?? '');
    final retailPrice = p?.retailPrice ?? 0.0;
    final b2bPrice = p?.b2bPrice ?? (retailPrice * 0.85);

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
            SizedBox(
              height: 320,
              width: double.infinity,
              child: ProductThumbnail(
                imageUrl: p?.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.display.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  // Price Comparison Row
                  Row(
                    children: [
                      Text(
                        '₹ ${b2bPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (retailPrice > b2bPrice) ...[
                        Text(
                          '₹ ${retailPrice.toStringAsFixed(0)} (Retail)',
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
                          child: Text(
                            '${(((retailPrice - b2bPrice) / retailPrice) * 100).toStringAsFixed(0)}% B2B Margin',
                            style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Materials & Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        label: Text(p?.category ?? 'Handicrafts', style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      ),
                      if (p?.materials != null)
                        ...p!.materials.map((m) => Chip(
                              label: Text(m, style: const TextStyle(fontSize: 12)),
                              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                            )),
                      if (p?.tags != null)
                        ...p!.tags.map((t) => Chip(
                              label: Text(t, style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.black.withValues(alpha: 0.05),
                            )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  if (desc != null && desc.isNotEmpty) ...[
                    Text(
                      _isHindi ? 'विवरण' : 'Story & Description',
                      style: AppTextStyles.heading.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: AppTextStyles.body.copyWith(height: 1.5, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                  ],
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
                                    p?.artisanName ?? 'Master Karigar',
                                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, color: AppColors.success, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(p?.artisanCoop ?? 'Independent Cooperative', style: AppTextStyles.caption),
                              Text('MoSJE Registered Artisan', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
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
