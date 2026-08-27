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

  void _registerStall(ExhibitionModel ex) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.registerForExhibition(ex.id);
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(
            '🎉 Registered stall for ${ex.name}! MoSJE stall badge issued.',
          ),
        ),
      );
      _fetchExhibitions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('National Exhibitions & Melas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _exhibitions.length,
              itemBuilder: (context, index) {
                final ex = _exhibitions[index];
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
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            StatusBadge(status: ex.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                ex.location,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${ex.startDate}  to  ${ex.endDate}',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: ex.isRegistered
                              ? 'Registered Stall ✓'
                              : 'Register for Stall (Free)',
                          variant: ex.isRegistered
                              ? AppButtonVariant.outlined
                              : AppButtonVariant.primary,
                          height: 48,
                          onPressed: ex.isRegistered
                              ? null
                              : () => _registerStall(ex),
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
