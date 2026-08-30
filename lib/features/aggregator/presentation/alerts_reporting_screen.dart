import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/scheme_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

class AlertsReportingScreen extends ConsumerStatefulWidget {
  const AlertsReportingScreen({super.key});

  @override
  ConsumerState<AlertsReportingScreen> createState() => _AlertsReportingScreenState();
}

class _AlertsReportingScreenState extends ConsumerState<AlertsReportingScreen> {
  bool _isLoading = true;
  List<GovtSchemeModel> _schemes = [];
  String? _firstClusterId;
  int _totalArtisans = 0;
  String _clusterState = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() => _isLoading = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final results = await Future.wait([
        apiClient.getSchemes(),
        apiClient.getAggregatorDashboard(),
      ]);
      final schemes = results[0] as List<GovtSchemeModel>;
      final dashboard = results[1] as Map<String, dynamic>;
      final clusters = (dashboard['clusters'] as List<dynamic>? ?? []);
      if (mounted) {
        setState(() {
          _schemes = schemes;
          _totalArtisans = dashboard['total_artisans'] ?? 0;
          if (clusters.isNotEmpty) {
            final first = clusters[0] as Map<String, dynamic>;
            _firstClusterId = first['cluster_id']?.toString();
            _clusterState = first['state']?.toString() ?? '';
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRelayAlertSheet() {
    final stateController = TextEditingController(text: _clusterState);
    final craftController = TextEditingController();
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Relay Scheme Alert to Artisans', style: AppTextStyles.heading.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Broadcast push notifications to all registered artisans under your cluster.', style: AppTextStyles.caption),
                  const SizedBox(height: 16),
                  TextField(controller: stateController, decoration: const InputDecoration(labelText: 'Target State')),
                  const SizedBox(height: 12),
                  TextField(controller: craftController, decoration: const InputDecoration(labelText: 'Target Craft (optional)')),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Broadcast to $_totalArtisans Artisans',
                    icon: Icons.send,
                    isLoading: isSending,
                    onPressed: () async {
                      setSheetState(() => isSending = true);
                      try {
                        await ref.read(apiClientProvider).relayScheme(
                          schemeId: _firstClusterId ?? '',
                          targetState: stateController.text.trim(),
                          targetCraft: craftController.text.trim(),
                        );
                      } catch (_) {}
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: AppColors.success, content: Text('Scheme alert broadcasted to cluster!')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSubmitReportSheet() {
    final summaryController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Submit Monthly Report to MoSJE', style: AppTextStyles.heading.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Submit cluster progress, digitization milestones, and welfare disbursement notes to Ministry Admin.', style: AppTextStyles.caption),
                  const SizedBox(height: 16),
                  TextField(
                    controller: summaryController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Enter monthly progress summary, toolkits distributed, and field remarks...'),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Submit Official Report',
                    isLoading: isSubmitting,
                    onPressed: () async {
                      if (summaryController.text.trim().isEmpty) return;
                      setSheetState(() => isSubmitting = true);
                      try {
                        await ref.read(apiClientProvider).submitClusterReport(
                          clusterId: _firstClusterId ?? '',
                          reportMonth: '${_monthName(DateTime.now().month)} ${DateTime.now().year}',
                          summary: summaryController.text.trim(),
                        );
                      } catch (_) {}
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: AppColors.success, content: Text('Monthly report submitted to MoSJE Admin.')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _monthName(int month) {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alerts & MoSJE Reporting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetch(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(child: AppButton(label: 'Relay Scheme', icon: Icons.campaign, onPressed: _showRelayAlertSheet)),
                      const SizedBox(width: 12),
                      Expanded(child: AppButton(label: 'Submit Report', variant: AppButtonVariant.outlined, icon: Icons.assignment_turned_in, onPressed: _showSubmitReportSheet)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Active Government Schemes', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  if (_schemes.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No active schemes at this time.', style: TextStyle(color: AppColors.textSecondary)),
                    ))
                  else
                    ..._schemes.where((s) => s.isActive).map((scheme) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(scheme.schemeName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(scheme.description, style: AppTextStyles.caption.copyWith(fontSize: 13, height: 1.4)),
                            if (scheme.eligibilityCriteria != null) ...[
                              const SizedBox(height: 4),
                              Text('Eligibility: ${scheme.eligibilityCriteria}', style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                            ],
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
                    )),
                ],
              ),
            ),
    );
  }
}
