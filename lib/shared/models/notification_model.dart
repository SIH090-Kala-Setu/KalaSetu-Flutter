class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // System, Inquiry, Verification, Update
  final bool isRead;
  final String? sentAt;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'System',
    this.isRead = false,
    this.sentAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'System',
      isRead: json['is_read'] == true,
      sentAt: json['sent_at']?.toString(),
    );
  }
}

