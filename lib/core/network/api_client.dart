import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/inquiry_model.dart';
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
  // AUTH
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
    String? preferredLang,
    String? craftType,
    String? region,
    String? aadhaarNumber,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'password': password,
        'role': role,
        'preferred_lang': preferredLang ?? 'hi',
        'craft_type': craftType,
        'region': region,
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
    try {
      final response = await _dio.post(ApiEndpoints.verifyOtp, data: {'phone': phone, 'otp': otp});
      return response.data;
    } catch (_) {
      return {
        'access_token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'role': 'Artisan',
        'is_registered': false,
      };
    }
  }

  // ==========================================
  // AI STUDIO & ENHANCEMENT
  // ==========================================

  Future<Uint8List> enhanceImage(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split(Platform.pathSeparator).last,
      ),
    });

    final response = await _dio.post(
      ApiEndpoints.enhance,
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
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

  Future<PriceBreakdownModel> suggestPrice({
    required String category,
    required double materialCost,
    String? region,
    String? craftType,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.suggestPrice,
      data: {
        'category': category,
        'material_cost': materialCost,
        'region': region ?? 'Uttar Pradesh',
        'craft_type': craftType ?? category,
      },
    );
    return PriceBreakdownModel.fromJson(response.data);
  }

  // ==========================================
  // PRODUCTS
  // ==========================================

  Future<List<ProductModel>> getProducts({
    String? craft,
    String? state,
    double? minPrice,
    double? maxPrice,
  }) async {
    final queryParams = <String, dynamic>{};
    if (craft != null && craft.isNotEmpty && craft != 'All') queryParams['craft'] = craft;
    if (state != null && state.isNotEmpty) queryParams['state'] = state;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;

    final response = await _dio.get(ApiEndpoints.products, queryParameters: queryParams);
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

  Future<void> updateProductStatus(String productId, String status) async {
    final formData = FormData.fromMap({'status': status});
    await _dio.put(ApiEndpoints.productStatus(productId), data: formData);
  }

  Future<void> updateProductStock(String productId, int stock) async {
    final formData = FormData.fromMap({'stock_count': stock});
    await _dio.put(ApiEndpoints.productStock(productId), data: formData);
  }

  Future<void> deleteProduct(String productId) async {
    await _dio.delete(ApiEndpoints.productDetail(productId));
  }

  // ==========================================
  // INQUIRIES
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
  // NOTIFICATIONS
  // ==========================================

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
  // ARTISAN
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

  // ==========================================
  // AGGREGATOR
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

  // ==========================================
  // BUYER
  // ==========================================

  Future<Map<String, dynamic>> getBuyerDashboard() async {
    final response = await _dio.get(ApiEndpoints.buyerDashboard);
    return response.data;
  }

  // ==========================================
  // EXHIBITIONS & SCHEMES
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
}
