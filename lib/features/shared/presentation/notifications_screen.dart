import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/widgets/app_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _isLoading = true;
  List<AppNotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _notifications = [
            AppNotificationModel(
              id: 'n1',
              title: 'New Bulk Order Inquiry',
              message: 'FabIndia has submitted an RFQ for 50 pieces of Banarasi Handloom Scarves.',
              type: 'Inquiry',
              sentAt: '2 hours ago',
            ),
            AppNotificationModel(
              id: 'n2',
              title: 'Government Scheme Alert',
              message: 'PM Vishwakarma ₹15,000 modern toolkits disbursement is now open for your cluster.',
              type: 'Scheme',
              sentAt: 'Yesterday',
            ),
            AppNotificationModel(
              id: 'n3',
              title: 'Exhibition Stall Confirmed',
              message: 'Your stall application for Shilp Samagam 2026 at Dilli Haat has been approved by MoSJE.',
              type: 'Verification',
              sentAt: '2 days ago',
            ),
          ];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () async {
              final apiClient = ref.read(apiClientProvider);
              await apiClient.markAllNotificationsRead();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                IconData icon;
                Color iconColor;

                if (notif.type == 'Inquiry') {
                  icon = Icons.chat_bubble_outline;
                  iconColor = AppColors.primary;
                } else if (notif.type == 'Scheme') {
                  icon = Icons.campaign;
                  iconColor = AppColors.accent;
                } else {
                  icon = Icons.verified_outlined;
                  iconColor = AppColors.success;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: iconColor.withValues(alpha: 0.12),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                notif.message,
                                style: AppTextStyles.caption.copyWith(fontSize: 13, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text(notif.sentAt ?? 'Recent', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
