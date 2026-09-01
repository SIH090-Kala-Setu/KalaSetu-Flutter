import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/inquiry_model.dart';
import '../../shared/models/cluster_model.dart';
import '../../shared/models/exhibition_model.dart';
import '../../shared/models/scheme_model.dart';
import '../../shared/models/notification_model.dart';
import 'api_endpoints.dart';
import 'dio_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // ==========================================
  // AUTH (Module 1)
  // ==========================================

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );
    return response.data;
  }

  Future<UserModel> register({
    required String username,
    required String password,
    required String role,
    String? fullName,
    String? preferredLang,
    String? craftType,
    String? region,
    String? district,
    String? aadhaarNumber,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'password': password,
        'role': role,
        'full_name': fullName,
        'preferred_lang': preferredLang ?? 'hi',
        'craft_type': craftType,
        'region': region,
        'district': district,
        'aadhaar_number': aadhaarNumber,
      },
    );
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getMe() async {
    final response = await _dio.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data);
  }

  Future<bool> sendOtp(String phone) async {
    try {
      await _dio.post(ApiEndpoints.sendOtp, data: {'phone': phone});
      return true;
    } catch (_) {
      return true;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    return response.data;
  }

  // ==========================================
  // AI STUDIO & ENHANCEMENT (Module 2, 3, 4)
  // ==========================================

  Future<Uint8List> enhanceImage({File? imageFile, Uint8List? imageBytes, String filename = 'product.png'}) async {
    MultipartFile filePart;
    if (imageBytes != null && imageBytes.isNotEmpty) {
      filePart = MultipartFile.fromBytes(imageBytes, filename: filename);
    } else if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      filePart = MultipartFile.fromBytes(bytes, filename: filename);
    } else {
      throw ArgumentError('Either imageBytes or imageFile must be provided');
    }

    final formData = FormData.fromMap({
      'file': filePart,
    });

    final response = await _dio.post(
      ApiEndpoints.enhance,
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
  }

  Future<List<Map<String, dynamic>>> enhanceBatch(List<File> imageFiles) async {
    final files = <MultipartFile>[];
    for (final f in imageFiles) {
      files.add(
        await MultipartFile.fromFile(
          f.path,
          filename: f.path.split(Platform.pathSeparator).last,
        ),
      );
    }

    final formData = FormData.fromMap({'files': files});
    final response = await _dio.post(ApiEndpoints.enhanceBatch, data: formData);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<ProductCatalogGenerated> generateCatalog({
    File? audioFile,
    String? textDesc,
    String lang = 'Hindi',
  }) async {
    final map = <String, dynamic>{'lang': lang};
    if (audioFile != null) {
      map['audio'] = await MultipartFile.fromFile(
        audioFile.path,
        filename: audioFile.path.split(Platform.pathSeparator).last,
      );
    }
    if (textDesc != null) {
      map['text_desc'] = textDesc;
    }

    final formData = FormData.fromMap(map);
    final response = await _dio.post(ApiEndpoints.catalog, data: formData);
    return ProductCatalogGenerated.fromJson(response.data);
  }

  Future<ProductCatalogGenerated> generateCatalogFromImage(Uint8List imageBytes) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(imageBytes, filename: 'product.jpg'),
    });
    final response = await _dio.post(ApiEndpoints.catalogVision, data: formData);
    return ProductCatalogGenerated.fromJson(response.data);
  }

  Future<PriceBreakdownModel> suggestPrice({
    required String category,
    required double materialCost,
    double manufacturingHours = 4.0,
    String productDescription = '',
    Uint8List? imageBytes,
    String? regionState,
    int? artisanExperienceYrs,
    int? productComplexity,
    bool? giTagCertified,
    int? bulkOrderQty,
    String? materialType,
  }) async {
    final formData = FormData.fromMap({
      'category': category,
      'material_cost': materialCost,
      'manufacturing_hours': manufacturingHours,
      'product_description': productDescription,
      if (regionState != null) 'region_state': regionState,
      if (artisanExperienceYrs != null) 'artisan_experience_yrs': artisanExperienceYrs,
      if (productComplexity != null) 'product_complexity': productComplexity,
      if (giTagCertified != null) 'gi_tag_certified': giTagCertified,
      if (bulkOrderQty != null) 'bulk_order_qty': bulkOrderQty,
      if (materialType != null) 'material_type': materialType,
      if (imageBytes != null && imageBytes.isNotEmpty)
        'image': MultipartFile.fromBytes(imageBytes, filename: 'product.jpg'),
    });
    final response = await _dio.post(
      ApiEndpoints.suggestPrice,
      data: formData,
    );
    return PriceBreakdownModel.fromJson(response.data);
  }

  Future<PriceBreakdownModel> predictPriceML(Map<String, dynamic> payload) async {
    final response = await _dio.post(
      ApiEndpoints.predictPrice,
      data: payload,
    );
    return PriceBreakdownModel.fromJson(response.data);
  }

  // ==========================================
  // PRODUCTS & INVENTORY (Module 5)
  // ==========================================

  Future<List<ProductModel>> getProducts({
    String? craft,
    String? state,
    double? minPrice,
    double? maxPrice,
    int limit = 40,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (craft != null && craft.isNotEmpty && craft != 'All') {
      queryParams['category'] = craft;
    }
    if (state != null && state.isNotEmpty) {
      queryParams['region'] = state;
    }
    if (minPrice != null) {
      queryParams['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      queryParams['max_price'] = maxPrice;
    }

    final response = await _dio.get(
      ApiEndpoints.products,
      queryParameters: queryParams,
    );
    final list = response.data as List<dynamic>;
    return list.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProductDetail(String productId) async {
    final response = await _dio.get(ApiEndpoints.productDetail(productId));
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> createProduct({
    required String titleEn,
    required String titleHi,
    String? descriptionEn,
    String? descriptionHi,
    required String category,
    List<String>? materials,
    List<String>? tags,
    required double retailPrice,
    required double b2bPrice,
    int stock = 10,
    String? imageUrl,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.products,
      data: {
        'title_en': titleEn,
        'title_hi': titleHi,
        'description_en': descriptionEn,
        'description_hi': descriptionHi,
        'category': category,
        'materials': materials ?? [],
        'tags': tags ?? [],
        'retail_price': retailPrice,
        'b2b_price': b2bPrice,
        'stock': stock,
        'image_url': imageUrl,
      },
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.productDetail(productId),
      data: data,
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> updateProductStatus(String productId, String status) async {
    final formData = FormData.fromMap({'status': status});
    await _dio.put(ApiEndpoints.productStatus(productId), data: formData);
  }

  Future<void> updateProductStock(String productId, int stock) async {
    final formData = FormData.fromMap({'stock_count': stock});
    await _dio.put(ApiEndpoints.productStock(productId), data: formData);
  }

  Future<void> updateProductPrice(
    String productId, {
    required double basePrice,
    double? suggestedPrice,
  }) async {
    final formData = FormData.fromMap({
      'base_price': basePrice,
      ...?suggestedPrice != null ? {'suggested_price': suggestedPrice} : null,
    });
    await _dio.put(ApiEndpoints.productPrice(productId), data: formData);
  }

  Future<Uint8List> getProductQr(String productId) async {
    final response = await _dio.get(
      ApiEndpoints.productQr(productId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }

  Future<void> deleteProduct(String productId) async {
    await _dio.delete(ApiEndpoints.productDetail(productId));
  }

  // ==========================================
  // INQUIRIES & MARKET LINKAGE (Module 6)
  // ==========================================

  Future<List<InquiryModel>> getInquiries() async {
    final response = await _dio.get(ApiEndpoints.inquiries);
    final list = response.data as List<dynamic>;
    return list.map((json) => InquiryModel.fromJson(json)).toList();
  }

  Future<InquiryModel> createInquiry({
    required String productId,
    required String buyerName,
    required String buyerEmail,
    required int quantity,
    String? notes,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.inquiries,
      data: {
        'product_id': productId,
        'buyer_name': buyerName,
        'buyer_email': buyerEmail,
        'quantity': quantity,
        'notes': notes,
      },
    );
    return InquiryModel.fromJson(response.data);
  }

  Future<void> respondToInquiry(String inquiryId, String message) async {
    final formData = FormData.fromMap({'response_message': message});
    await _dio.post(ApiEndpoints.respondInquiry(inquiryId), data: formData);
  }

  // ==========================================
  // NOTIFICATIONS (Module 8)
  // ==========================================

  Future<void> registerFcmToken(String token) async {
    await _dio.post('/auth/fcm-token', data: {'fcm_token': token});
  }

  Future<List<AppNotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final list = response.data as List<dynamic>;
    return list.map((json) => AppNotificationModel.fromJson(json)).toList();
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.put(ApiEndpoints.markNotificationRead(id));
  }

  Future<void> markAllNotificationsRead() async {
    await _dio.put(ApiEndpoints.markAllNotificationsRead);
  }

  // ==========================================
  // ARTISAN PROFILE & ANALYTICS (Module 7 & 9)
  // ==========================================

  Future<Map<String, dynamic>> getArtisanDashboard() async {
    final response = await _dio.get(ApiEndpoints.artisanDashboard);
    return response.data;
  }

  Future<Map<String, dynamic>> getArtisanProfile() async {
    final response = await _dio.get(ApiEndpoints.artisanProfile);
    return response.data;
  }

  Future<void> updateArtisanProfile(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    await _dio.put(ApiEndpoints.artisanProfile, data: formData);
  }

  Future<Map<String, dynamic>> getArtisanAnalytics() async {
    final response = await _dio.get(ApiEndpoints.artisanAnalytics);
    return response.data;
  }

  Future<String> getArtisanReport() async {
    final response = await _dio.get(ApiEndpoints.artisanReport);
    return response.data.toString();
  }

  // ==========================================
  // AGGREGATOR & CLUSTERS (Module 9)
  // ==========================================

  Future<Map<String, dynamic>> getAggregatorDashboard() async {
    final response = await _dio.get(ApiEndpoints.aggregatorDashboard);
    return response.data;
  }

  Future<List<UserModel>> getAggregatorArtisans() async {
    final response = await _dio.get(ApiEndpoints.aggregatorArtisans);
    final list = (response.data['artisans'] ?? response.data) as List<dynamic>;
    return list.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> onboardArtisan({
    required String fullName,
    required String phone,
    required String craftType,
    String? clusterName,
    String preferredLanguage = 'hi',
  }) async {
    await _dio.post(
      ApiEndpoints.aggregatorOnboard,
      data: {
        'full_name': fullName,
        'phone': phone,
        'craft_type': craftType,
        'cluster_name': clusterName,
        'preferred_language': preferredLanguage,
      },
    );
  }

  Future<void> relayScheme({
    required String schemeId,
    required String targetState,
    required String targetCraft,
  }) async {
    await _dio.post(
      ApiEndpoints.aggregatorRelayScheme,
      data: {
        'scheme_id': schemeId,
        'target_state': targetState,
        'target_craft': targetCraft,
      },
    );
  }

  Future<void> submitClusterReport({
    required String clusterId,
    required String reportMonth,
    required String summary,
  }) async {
    await _dio.post(
      ApiEndpoints.aggregatorSubmitReport,
      data: {
        'cluster_id': clusterId,
        'report_month': reportMonth,
        'summary': summary,
      },
    );
  }

  Future<List<ClusterModel>> getClusters() async {
    final response = await _dio.get(ApiEndpoints.clusters);
    final list = response.data as List<dynamic>;
    return list.map((json) => ClusterModel.fromJson(json)).toList();
  }

  Future<List<ClusterModel>> getMyClusters() async {
    final response = await _dio.get(ApiEndpoints.myClusters);
    final list = response.data as List<dynamic>;
    return list.map((json) => ClusterModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> getClusterArtisans(String clusterId) async {
    final response = await _dio.get(ApiEndpoints.clusterArtisans(clusterId));
    final list = response.data as List<dynamic>;
    return list.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> addArtisanToCluster(String clusterId, String artisanId) async {
    await _dio.post(
      ApiEndpoints.clusterArtisans(clusterId),
      data: {'artisan_id': artisanId},
    );
  }

  Future<List<ClusterModel>> getClustersUnassigned() async {
    final response = await _dio.get(ApiEndpoints.clusters, queryParameters: {'unassigned': true});
    final list = response.data as List<dynamic>;
    return list.map((json) => ClusterModel.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> joinCluster(String clusterId) async {
    final response = await _dio.post(
      '/aggregator/join-cluster',
      data: {'cluster_id': clusterId},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<ClusterModel> createCluster({
    required String clusterName,
    required String state,
    required String district,
    String? craftSpecialization,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.clusters,
      data: {
        'cluster_name': clusterName,
        'state': state,
        'district': district,
        'craft_specialization': craftSpecialization ?? 'General Crafts',
      },
    );
    return ClusterModel.fromJson(response.data);
  }


  // ==========================================
  // BUYER (Module 6 & 9)
  // ==========================================

  Future<Map<String, dynamic>> getBuyerDashboard() async {
    final response = await _dio.get(ApiEndpoints.buyerDashboard);
    return response.data;
  }

  // ==========================================
  // EXHIBITIONS & SCHEMES (Module 6 & 8)
  // ==========================================

  Future<List<ExhibitionModel>> getExhibitions() async {
    final response = await _dio.get(ApiEndpoints.exhibitions);
    final list = response.data as List<dynamic>;
    return list.map((json) => ExhibitionModel.fromJson(json)).toList();
  }

  Future<void> registerForExhibition(String exhibitionId) async {
    await _dio.post(ApiEndpoints.registerExhibition(exhibitionId));
  }

  Future<List<GovtSchemeModel>> getSchemes() async {
    final response = await _dio.get(ApiEndpoints.schemes);
    final list = response.data as List<dynamic>;
    return list.map((json) => GovtSchemeModel.fromJson(json)).toList();
  }

  // ==========================================
  // PRODUCT REVIEWS
  // ==========================================

  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final response = await _dio.get(ApiEndpoints.productReviews(productId));
    final list = response.data as List<dynamic>;
    return list.map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<ReviewModel> createProductReview({
    required String productId,
    required int rating,
    String? comment,
    String? reviewerName,
    bool isRecommended = true,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.productReviews(productId),
      data: {
        'rating': rating,
        'comment': comment ?? '',
        'reviewer_name': reviewerName,
        'is_recommended': isRecommended,
      },
    );
    return ReviewModel.fromJson(response.data as Map<String, dynamic>);
  }
}

