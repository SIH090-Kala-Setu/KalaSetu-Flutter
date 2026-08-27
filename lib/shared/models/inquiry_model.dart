import 'product_model.dart';

class InquiryModel {
  final String id;
  final String productId;
  final String buyerName;
  final String buyerEmail;
  final int quantity;
  final String? notes;
  final String? message;
  final String status; // Pending, Responded, Completed
  final String? createdAt;
  final ProductModel? product;

  InquiryModel({
    required this.id,
    required this.productId,
    required this.buyerName,
    required this.buyerEmail,
    this.quantity = 1,
    this.notes,
    this.message,
    this.status = 'Pending',
    this.createdAt,
    this.product,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id']?.toString() ?? json['inquiry_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      buyerName: json['buyer_name']?.toString() ?? 'B2B Enterprise Buyer',
      buyerEmail: json['buyer_email']?.toString() ?? 'buyer@enterprise.com',
      quantity: json['quantity'] ?? 1,
      notes: json['notes']?.toString(),
      message: json['message']?.toString() ?? json['notes']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['created_at']?.toString(),
      product: json['product'] != null ? ProductModel.fromJson(json['product']) : null,
    );
  }
}

