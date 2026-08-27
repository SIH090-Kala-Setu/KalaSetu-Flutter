import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  final _searchController = TextEditingController();
  String _selectedCraft = 'All';
  bool _isLoading = true;
  List<ProductModel> _products = [];

  final List<String> _craftCategories = [
    'All',
    'Textiles & Handloom',
    'Clay & Pottery',
    'Jewelry & Silver',
    'Woodwork & Inlay',
    'Folk Paintings',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMarketplaceProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchMarketplaceProducts() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getProducts(craft: _selectedCraft);
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
              id: 'bp1',
              titleEn: 'Handwoven Banarasi Katan Silk Saree',
              titleHi: 'बनारसी कातन सिल्क साड़ी',
              category: 'Textiles & Handloom',
              retailPrice: 5800,
              b2bPrice: 4200,
              stock: 25,
              status: 'Active',
              artisanName: 'Ramesh Chandra Weaver',
              artisanCoop: 'Varanasi Silk Weaver Cluster',
            ),
            ProductModel(
              id: 'bp2',
              titleEn: 'Traditional Blue Glazed Terracotta Planter',
              titleHi: 'नीला मिट्टी का गमला',
              category: 'Clay & Pottery',
              retailPrice: 1200,
              b2bPrice: 750,
              stock: 50,
              status: 'Active',
              artisanName: 'Kailash Potter',
              artisanCoop: 'Jaipur Blue Pottery Cluster',
            ),
            ProductModel(
              id: 'bp3',
              titleEn: 'Silver Filigree Cuttack Peacock Brooch',
              titleHi: 'चांदी की मोर ब्रोच',
              category: 'Jewelry & Silver',
              retailPrice: 3800,
              b2bPrice: 2800,
              stock: 15,
              status: 'Active',
              artisanName: 'Debendra Sahoo',
              artisanCoop: 'Cuttack Silver Artisans Society',
            ),
            ProductModel(
              id: 'bp4',
              titleEn: 'Sheesham Wood Inlay Jewellery Box',
              titleHi: 'शीशम की लकड़ी का बॉक्स',
              category: 'Woodwork & Inlay',
              retailPrice: 1950,
              b2bPrice: 1350,
              stock: 30,
              status: 'Active',
              artisanName: 'Mohd. Imran',
              artisanCoop: 'Saharanpur Woodcraft Guild',
            ),
          ];
          _isLoading = false;
        });
      }
    }
  }

  List<ProductModel> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((p) {
      final matchesQuery = p.titleEn.toLowerCase().contains(query) ||
          p.titleHi.toLowerCase().contains(query) ||
          (p.artisanName?.toLowerCase().contains(query) ?? false);
      if (!matchesQuery) return false;

      if (_selectedCraft != 'All' && p.category != _selectedCraft) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KalaSetu B2B Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter by state, price bracket, and MoSJE badge')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search products, crafts, or master weavers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _craftCategories.map((craft) {
                      final isSelected = _selectedCraft == craft;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(craft),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() => _selectedCraft = craft);
                              _fetchMarketplaceProducts();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Product Grid
          Expanded(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerGridLoader(itemCount: 4),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          context.push('/buyer/product/${p.id}');
                        },
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
                              // Product Thumbnail
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Container(
                                    color: AppColors.primary.withValues(alpha: 0.06),
                                    child: const Center(
                                      child: Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.titleEn,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.artisanName ?? 'Verified Master Artisan',
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '₹ ${p.b2bPrice.toStringAsFixed(0)}',
                                          style: AppTextStyles.heading.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'B2B Wholesale',
                                          style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.success),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Min Order: 10 units',
                                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                                    ),
                                  ],
                                ),
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
