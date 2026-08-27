class ProductModel {
  final String id;
  final String titleEn;
  final String titleHi;
  final String? descriptionEn;
  final String? descriptionHi;
  final String category;
  final List<String> materials;
  final List<String> tags;
  final double retailPrice;
  final double b2bPrice;
  final int stock;
  final String status; // Active, Draft, Sold Out, Archived, Pending Review
  final String? imageUrl;
  final String? artisanName;
  final String? artisanCoop;
  final String? artisanId;
  final int viewCount;

  ProductModel({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    this.descriptionEn,
    this.descriptionHi,
    required this.category,
    this.materials = const [],
    this.tags = const [],
    required this.retailPrice,
    required this.b2bPrice,
    this.stock = 1,
    this.status = 'Active',
    this.imageUrl,
    this.artisanName,
    this.artisanCoop,
    this.artisanId,
    this.viewCount = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      titleHi: json['title_hi']?.toString() ?? json['title_en']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString(),
      descriptionHi: json['description_hi']?.toString(),
      category: json['category']?.toString() ?? json['craft_category']?.toString() ?? 'Handicrafts',
      materials: (json['materials'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      retailPrice: (json['retail_price'] ?? json['base_price'] ?? 0).toDouble(),
      b2bPrice: (json['b2b_price'] ?? json['suggested_price'] ?? json['retail_price'] ?? 0).toDouble(),
      stock: json['stock'] ?? json['stock_count'] ?? 1,
      status: json['status']?.toString() ?? 'Active',
      imageUrl: json['image_url']?.toString() ?? (json['images'] is List && (json['images'] as List).isNotEmpty ? json['images'][0]?.toString() : null),
      artisanName: json['artisan_name']?.toString(),
      artisanCoop: json['artisan_coop']?.toString(),
      artisanId: json['artisan_id']?.toString(),
      viewCount: json['view_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_hi': titleHi,
      'description_en': descriptionEn,
      'description_hi': descriptionHi,
      'category': category,
      'materials': materials,
      'tags': tags,
      'retail_price': retailPrice,
      'b2b_price': b2bPrice,
      'stock': stock,
      'status': status,
      'image_url': imageUrl,
      'artisan_name': artisanName,
    };
  }
}

class ProductCatalogGenerated {
  final String titleEn;
  final String titleHi;
  final String descriptionEn;
  final String descriptionHi;
  final String craftCategory;
  final String primaryMaterial;
  final List<String> suggestedTags;
  final String? transcribedText;

  ProductCatalogGenerated({
    required this.titleEn,
    required this.titleHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.craftCategory,
    required this.primaryMaterial,
    required this.suggestedTags,
    this.transcribedText,
  });

  factory ProductCatalogGenerated.fromJson(Map<String, dynamic> json) {
    return ProductCatalogGenerated(
      titleEn: json['title_en']?.toString() ?? '',
      titleHi: json['title_hi']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionHi: json['description_hi']?.toString() ?? '',
      craftCategory: json['craft_category']?.toString() ?? 'Handicrafts',
      primaryMaterial: json['primary_material']?.toString() ?? 'Natural',
      suggestedTags: (json['suggested_tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      transcribedText: json['transcribed_text']?.toString(),
    );
  }
}

class PriceBreakdownModel {
  final double suggestedRetailPrice;
  final double suggestedB2BPrice;
  final double minimumBreakevenPrice;
  final double estimatedProfitMargin;
  final String explanation;

  PriceBreakdownModel({
    required this.suggestedRetailPrice,
    required this.suggestedB2BPrice,
    required this.minimumBreakevenPrice,
    required this.estimatedProfitMargin,
    required this.explanation,
  });

  factory PriceBreakdownModel.fromJson(Map<String, dynamic> json) {
    return PriceBreakdownModel(
      suggestedRetailPrice: (json['suggested_retail_price'] ?? json['suggested_price'] ?? 0).toDouble(),
      suggestedB2BPrice: (json['suggested_b2b_price'] ?? json['b2b_price'] ?? 0).toDouble(),
      minimumBreakevenPrice: (json['minimum_breakeven_price'] ?? json['min_price'] ?? 0).toDouble(),
      estimatedProfitMargin: (json['estimated_profit_margin_percent'] ?? json['profit_margin'] ?? 25).toDouble(),
      explanation: json['explanation']?.toString() ?? 'Calculated using fair wage multiplier and raw material costs.',
    );
  }
}

