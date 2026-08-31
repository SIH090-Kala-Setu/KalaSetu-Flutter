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
    List<String> tagsList = [];
    if (json['tags'] is List) {
      tagsList = (json['tags'] as List).map((e) => e.toString()).toList();
    } else if (json['suggested_tags'] is List) {
      tagsList = (json['suggested_tags'] as List).map((e) => e.toString()).toList();
    }

    String materialStr = 'Natural';
    if (json['materials'] is List && (json['materials'] as List).isNotEmpty) {
      materialStr = (json['materials'] as List).map((e) => e.toString()).join(', ');
    } else if (json['primary_material'] != null) {
      materialStr = json['primary_material'].toString();
    }

    return ProductCatalogGenerated(
      titleEn: json['title_en']?.toString() ?? '',
      titleHi: json['title_hi']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionHi: json['description_hi']?.toString() ?? '',
      craftCategory: json['category']?.toString() ?? json['craft_category']?.toString() ?? 'Handicrafts',
      primaryMaterial: materialStr,
      suggestedTags: tagsList,
      transcribedText: json['raw_transcription']?.toString() ?? json['transcribed_text']?.toString(),
    );
  }
}

class PriceBreakdownModel {
  final double suggestedRetailPrice;
  final double suggestedB2BPrice;
  final double minimumBreakevenPrice;
  final double marketAvg;
  final double marketMin;
  final double marketMax;
  final String complexity;
  final String explanation;
  final String? competitorRange;
  final double? predictedPriceInr;
  final double? priceLowerBoundInr;
  final double? priceUpperBoundInr;
  final double? fairWageFloorInr;
  final bool floorCompliant;
  final List<Map<String, dynamic>>? shapTopFeatures;
  final String? mlEngineUsed;

  PriceBreakdownModel({
    required this.suggestedRetailPrice,
    required this.suggestedB2BPrice,
    required this.minimumBreakevenPrice,
    required this.marketAvg,
    required this.marketMin,
    required this.marketMax,
    required this.complexity,
    required this.explanation,
    this.competitorRange,
    this.predictedPriceInr,
    this.priceLowerBoundInr,
    this.priceUpperBoundInr,
    this.fairWageFloorInr,
    this.floorCompliant = true,
    this.shapTopFeatures,
    this.mlEngineUsed,
  });

  factory PriceBreakdownModel.fromJson(Map<String, dynamic> json) {
    final baseMat = (json['base_material_cost'] ?? 0).toDouble();
    final labor = (json['labor_cost'] ?? 0).toDouble();
    final minPrice = (json['min_price'] ?? json['minimum_breakeven_price'] ?? (baseMat + labor)).toDouble();
    final retail = (json['suggested_retail_price'] ?? json['predicted_price_inr'] ?? json['suggested_price'] ?? (minPrice * 1.5)).toDouble();
    final b2b = (json['suggested_b2b_price'] ?? json['b2b_price'] ?? (retail * 0.75)).toDouble();
    
    List<Map<String, dynamic>>? shapList;
    if (json['shap_top_features'] is List) {
      shapList = (json['shap_top_features'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return PriceBreakdownModel(
      suggestedRetailPrice: retail,
      suggestedB2BPrice: b2b,
      minimumBreakevenPrice: minPrice > 0 ? minPrice : (retail * 0.7),
      marketAvg: (json['market_avg'] ?? 0).toDouble(),
      marketMin: (json['market_min'] ?? 0).toDouble(),
      marketMax: (json['market_max'] ?? 0).toDouble(),
      complexity: json['complexity']?.toString() ?? 'moderate',
      explanation: json['pricing_strategy_notes']?.toString() ?? json['explanation']?.toString() ?? 'Calculated using fair wage multiplier and raw material costs.',
      competitorRange: json['competitor_range']?.toString(),
      predictedPriceInr: (json['predicted_price_inr'] ?? retail).toDouble(),
      priceLowerBoundInr: json['price_lower_bound_inr'] != null ? (json['price_lower_bound_inr'] as num).toDouble() : null,
      priceUpperBoundInr: json['price_upper_bound_inr'] != null ? (json['price_upper_bound_inr'] as num).toDouble() : null,
      fairWageFloorInr: json['fair_wage_floor_inr'] != null ? (json['fair_wage_floor_inr'] as num).toDouble() : null,
      floorCompliant: json['floor_compliant'] != false,
      shapTopFeatures: shapList,
      mlEngineUsed: json['ml_engine_used']?.toString(),
    );
  }
}

