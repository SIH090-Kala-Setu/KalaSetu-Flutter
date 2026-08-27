import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/app_button.dart';

class PhoneEntryScreen extends ConsumerStatefulWidget {
  final String role;

  const PhoneEntryScreen({super.key, required this.role});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10 || int.tryParse(phone) == null) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.sendOtp(phone);

      if (mounted) {
        context.push('/onboarding/otp?phone=$phone&role=${widget.role}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.enterMobile,
                style: AppTextStyles.display.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.enterMobileSub,
                style: AppTextStyles.caption.copyWith(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 36),
              // Phone Input Field with +91 pre-filled
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _errorMessage != null ? AppColors.error : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: AppColors.border)),
                      ),
                      child: Row(
                        children: [
                          const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            '+91',
                            style: AppTextStyles.heading.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: AppTextStyles.heading.copyWith(fontSize: 20, letterSpacing: 2),
                        decoration: InputDecoration(
                          hintText: '98765 43210',
                          hintStyle: AppTextStyles.heading.copyWith(
                            color: AppColors.textDisabled,
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (val) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const Spacer(),
              AppButton(
                label: l10n.sendOtp,
                isLoading: _isLoading,
                onPressed: _onSendOtp,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

