import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/exhibition_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';

class ExhibitionsScreen extends ConsumerStatefulWidget {
  const ExhibitionsScreen({super.key});

  @override
  ConsumerState<ExhibitionsScreen> createState() => _ExhibitionsScreenState();
}

class _ExhibitionsScreenState extends ConsumerState<ExhibitionsScreen> {
  bool _isLoading = true;
  List<ExhibitionModel> _exhibitions = [];

  @override
  void initState() {
    super.initState();
    _fetchExhibitions();
  }

  void _fetchExhibitions() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final list = await apiClient.getExhibitions();
      if (mounted) {
        setState(() {
          _exhibitions = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Track which exhibition IDs are currently registering (loading state)
  final Set<String> _registering = {};

  void _registerStall(ExhibitionModel ex) async {
    if (_registering.contains(ex.id)) return;
    setState(() => _registering.add(ex.id));
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.registerForExhibition(ex.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text('✅ Applied for stall at ${ex.name}! Pending MoSJE approval.'),
          ),
        );
        _fetchExhibitions(); // Refresh to get Pending state
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Failed to register: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _registering.remove(ex.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('National Exhibitions & Melas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchExhibitions(),
              child: _exhibitions.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No exhibitions available right now.', textAlign: TextAlign.center),
                    ),
                  )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _exhibitions.length,
              itemBuilder: (context, index) {
                final ex = _exhibitions[index];
                final isRegistering = _registering.contains(ex.id);

                // Determine button appearance based on 3 states
                final String buttonLabel;
                final AppButtonVariant buttonVariant;
                final VoidCallback? buttonOnPressed;

                if (ex.regStatus == 'Approved') {
                  buttonLabel = '✅ Stall Approved by MoSJE';
                  buttonVariant = AppButtonVariant.outlined;
                  buttonOnPressed = null;
                } else if (ex.isRegistered) {
                  buttonLabel = '⏳ Pending MoSJE Approval';
                  buttonVariant = AppButtonVariant.outlined;
                  buttonOnPressed = null;
                } else {
                  buttonLabel = isRegistering ? 'Registering...' : 'Register for Stall (Free)';
                  buttonVariant = AppButtonVariant.primary;
                  buttonOnPressed = isRegistering ? null : () => _registerStall(ex);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ex.name,
                                style: AppTextStyles.heading.copyWith(fontSize: 16),
                              ),
                            ),
                            StatusBadge(status: ex.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(ex.location,
                                  style: AppTextStyles.caption.copyWith(fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text('${ex.startDate}  to  ${ex.endDate}',
                                style: AppTextStyles.caption.copyWith(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: buttonLabel,
                          variant: buttonVariant,
                          height: 48,
                          isLoading: isRegistering,
                          onPressed: buttonOnPressed,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}
