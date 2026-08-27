import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

class AlertsReportingScreen extends ConsumerStatefulWidget {
  const AlertsReportingScreen({super.key});

  @override
  ConsumerState<AlertsReportingScreen> createState() =>
      _AlertsReportingScreenState();
}

class _AlertsReportingScreenState extends ConsumerState<AlertsReportingScreen> {
  void _showRelayAlertSheet() {
    final stateController = TextEditingController(text: 'Gujarat');
    final craftController = TextEditingController(text: 'Textiles & Handloom');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Relay Scheme Alert to Artisans',
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Broadcast SMS and push notifications to all registered artisans under your cluster.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'Target State'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: craftController,
                decoration: const InputDecoration(
                  labelText: 'Target Craft Specialization',
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Broadcast to 48 Artisans',
                icon: Icons.send,
                onPressed: () async {
                  final apiClient = ref.read(apiClientProvider);
                  await apiClient.relayScheme(
                    schemeId: 'scheme_pm_vishwakarma',
                    targetState: stateController.text,
                    targetCraft: craftController.text,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.success,
                      content: Text(
                        '📢 Scheme alert broadcasted to all cluster members!',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubmitReportSheet() {
    final reportSummaryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Submit Monthly Report to MoSJE',
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Submit cluster progress, digitization milestones, and welfare disbursement notes to Ministry Admin.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reportSummaryController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Enter monthly progress summary, toolkits distributed, and field remarks...',
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Submit Official Report',
                onPressed: () async {
                  final apiClient = ref.read(apiClientProvider);
                  await apiClient.submitClusterReport(
                    clusterId: 'cluster_patan_patola',
                    reportMonth: 'August 2026',
                    summary: reportSummaryController.text.trim().isNotEmpty
                        ? reportSummaryController.text.trim()
                        : '14 new weavers digitized; 48 products verified; ₹4.2L wholesale inquiries.',
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.success,
                      content: Text(
                        '✅ Monthly report formally submitted to MoSJE Admin console.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Alerts & MoSJE Reporting')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Action Buttons Card
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Relay Scheme',
                  icon: Icons.campaign,
                  onPressed: _showRelayAlertSheet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Submit Report',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.assignment_turned_in,
                  onPressed: _showSubmitReportSheet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Active Government Notifications',
            style: AppTextStyles.heading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PM Vishwakarma Scheme Round 2',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Collateral-free enterprise credit up to ₹3,00,000 at concessional 5% interest rate. Artisans in Patan cluster are eligible.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Broadcast to Cluster',
                  height: 40,
                  variant: AppButtonVariant.outlined,
                  onPressed: _showRelayAlertSheet,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shilp Samagam 2026 Registration Open',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Fair',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Ministry of Social Justice is offering 10 dedicated stalls for Patola handloom masters in New Delhi.',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
