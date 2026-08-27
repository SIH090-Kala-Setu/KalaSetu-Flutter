class GovtSchemeModel {
  final String id;
  final String schemeName;
  final String description;
  final String? eligibilityCriteria;
  final String? applicationUrl;
  final bool isActive;
  final String? validUntil;

  GovtSchemeModel({
    required this.id,
    required this.schemeName,
    required this.description,
    this.eligibilityCriteria,
    this.applicationUrl,
    this.isActive = true,
    this.validUntil,
  });

  factory GovtSchemeModel.fromJson(Map<String, dynamic> json) {
    return GovtSchemeModel(
      id: json['id']?.toString() ?? '',
      schemeName: json['scheme_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      eligibilityCriteria: json['eligibility_criteria']?.toString(),
      applicationUrl: json['application_url']?.toString(),
      isActive: json['is_active'] ?? true,
      validUntil: json['valid_until']?.toString(),
    );
  }
}

