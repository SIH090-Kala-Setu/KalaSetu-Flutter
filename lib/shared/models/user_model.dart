class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String role; // Artisan, Aggregator, Buyer, Admin
  final String preferredLanguage;
  final String state;
  final String district;
  final bool isVerified;
  final ArtisanProfileModel? artisanProfile;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    this.email,
    this.phoneNumber,
    required this.role,
    this.preferredLanguage = 'hi',
    this.state = 'Uttar Pradesh',
    this.district = 'Varanasi',
    this.isVerified = false,
    this.artisanProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName:
          json['full_name']?.toString() ??
          json['username']?.toString() ??
          'Artisan',
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      role: json['role']?.toString() ?? 'Artisan',
      preferredLanguage: json['preferred_language']?.toString() ?? 'hi',
      state: json['state']?.toString() ?? 'Uttar Pradesh',
      district: json['district']?.toString() ?? 'Varanasi',
      isVerified: json['is_verified'] == true,
      artisanProfile: json['artisan_profile'] != null
          ? ArtisanProfileModel.fromJson(json['artisan_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'preferred_language': preferredLanguage,
      'state': state,
      'district': district,
      'is_verified': isVerified,
    };
  }
}

class ArtisanProfileModel {
  final String? craftType;
  final String? clusterName;
  final String? aadhaarNumber;
  final String? bankAccount;
  final String? ifscCode;
  final String? upiId;
  final bool govtSchemeBeneficiary;
  final String? photoUrl;

  ArtisanProfileModel({
    this.craftType,
    this.clusterName,
    this.aadhaarNumber,
    this.bankAccount,
    this.ifscCode,
    this.upiId,
    this.govtSchemeBeneficiary = false,
    this.photoUrl,
  });

  factory ArtisanProfileModel.fromJson(Map<String, dynamic> json) {
    return ArtisanProfileModel(
      craftType: json['craft_type']?.toString(),
      clusterName: json['cluster_name']?.toString(),
      aadhaarNumber: json['aadhaar_number']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      ifscCode: json['ifsc_code']?.toString(),
      upiId: json['upi_id']?.toString(),
      govtSchemeBeneficiary: json['govt_scheme_beneficiary'] == true,
      photoUrl: json['photo_url']?.toString(),
    );
  }
}
