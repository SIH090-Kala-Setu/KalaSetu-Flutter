class ClusterModel {
  final String id;
  final String clusterName;
  final String state;
  final String district;
  final String? craftSpecialization;
  final String? aggregatorId;
  final int totalArtisans;
  final int activeListings;
  final int artisansNeedingSupport;

  ClusterModel({
    required this.id,
    required this.clusterName,
    required this.state,
    required this.district,
    this.craftSpecialization,
    this.aggregatorId,
    this.totalArtisans = 0,
    this.activeListings = 0,
    this.artisansNeedingSupport = 0,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json) {
    return ClusterModel(
      id: json['id']?.toString() ?? json['cluster_id']?.toString() ?? '',
      clusterName: json['cluster_name']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      craftSpecialization: json['craft_specialization']?.toString(),
      aggregatorId: json['aggregator_id']?.toString(),
      totalArtisans: json['total_artisans'] ?? 0,
      activeListings: json['active_product_listings'] ?? json['artisans_with_listings'] ?? 0,
      artisansNeedingSupport: json['artisans_needing_support'] ?? 0,
    );
  }
}

