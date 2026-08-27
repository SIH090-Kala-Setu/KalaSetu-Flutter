import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/empty_state.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = true;
  List<ProductModel> _products = [];

  final List<String> _filters = ['All', 'Active', 'Draft', 'Sold Out'];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getProducts();
      if (mounted) {
        setState(() {
          _products = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _products = [
            ProductModel(
              id: 'p1',
              titleEn: 'Pure Mulberry Silk Banarasi Saree',
              titleHi: 'शुद्ध रेशम बनारसी साड़ी',
              category: 'Textiles & Handloom',
              retailPrice: 4500,
              b2bPrice: 3400,
              stock: 8,
              status: 'Active',
              viewCount: 142,
            ),
            ProductModel(
              id: 'p2',
              titleEn: 'Handmade Terracotta Blue Pottery Vase',
              titleHi: 'हस्तनिर्मित नीले मिट्टी का फूलदान',
              category: 'Clay & Pottery',
              retailPrice: 850,
              b2bPrice: 600,
              stock: 15,
              status: 'Active',
              viewCount: 89,
            ),
            ProductModel(
              id: 'p3',
              titleEn: 'Tribal Silver Filigree Necklace',
              titleHi: 'चांदी का तारकशी हार',
              category: 'Jewelry & Silver',
              retailPrice: 3200,
              b2bPrice: 2500,
              stock: 0,
              status: 'Sold Out',
              viewCount: 210,
            ),
            ProductModel(
              id: 'p4',
              titleEn: 'Teak Wood Carved Wall Panel',
              titleHi: 'सागौन की लकड़ी का नक्काशीदार पैनल',
              category: 'Woodwork & Inlay',
              retailPrice: 2400,
              b2bPrice: 1800,
              stock: 3,
              status: 'Draft',
              viewCount: 12,
            ),
          ];
          _isLoading = false;
        });
      }
    }
  }

  List<ProductModel> get _filteredProducts {
    if (_selectedFilter == 'All') return _products;
    return _products
        .where((p) => p.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  void _showEditProductSheet(ProductModel product) {
    int stock = product.stock;

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
                  Text(
                    product.titleEn,
                    style: AppTextStyles.heading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock Available:', style: AppTextStyles.body),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (stock > 0) setSheetState(() => stock--);
                            },
                          ),
                          Text('$stock', style: AppTextStyles.heading),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setSheetState(() => stock++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Mark as Sold Out',
                    variant: AppButtonVariant.outlined,
                    onPressed: () async {
                      final apiClient = ref.read(apiClientProvider);
                      await apiClient.updateProductStatus(
                        product.id,
                        'Sold Out',
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _fetchProducts();
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Save Changes',
                    onPressed: () async {
                      final apiClient = ref.read(apiClientProvider);
                      await apiClient.updateProductStock(product.id, stock);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _fetchProducts();
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.myCatalogue),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catalog QR code generated for exhibitions'),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add_a_photo),
        label: Text(
          l10n.addProduct,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          context.push('/artisan/studio');
        },
      ),
      body: Column(
        children: [
          // Filter Chips Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: SingleChildScrollView(
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
          ),
          // Product Grid
          Expanded(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerGridLoader(itemCount: 4),
                  )
                : _filteredProducts.isEmpty
                ? EmptyStateWidget(
                    title: 'No products found',
                    message:
                        'Add your first product using the AI Camera Studio.',
                    buttonLabel: l10n.addProduct,
                    onButtonPressed: () => context.push('/artisan/studio'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14.0,
                          crossAxisSpacing: 14.0,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return Dismissible(
                        key: Key(p.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.archive, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref
                              .read(apiClientProvider)
                              .updateProductStatus(p.id, 'Sold Out');
                        },
                        child: InkWell(
                          onTap: () => _showEditProductSheet(p),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Product Image Placeholder
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Container(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.05,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.brush,
                                          size: 48,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StatusBadge(status: p.status),
                                      const SizedBox(height: 6),
                                      Text(
                                        p.titleEn,
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹ ${p.retailPrice.toStringAsFixed(0)}',
                                        style: AppTextStyles.heading.copyWith(
                                          fontSize: 15,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Stock: ${p.stock} units',
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
