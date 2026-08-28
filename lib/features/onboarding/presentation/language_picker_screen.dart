import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/widgets/app_button.dart';

class LanguageInfo {
  final String code;
  final String nativeName;
  final String englishName;
  final String flagEmoji;

  const LanguageInfo({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flagEmoji,
  });
}

class LanguagePickerScreen extends ConsumerStatefulWidget {
  const LanguagePickerScreen({super.key});

  @override
  ConsumerState<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends ConsumerState<LanguagePickerScreen> {
  static const List<LanguageInfo> _languages = [
    LanguageInfo(code: 'en', nativeName: 'English', englishName: 'English', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'hi', nativeName: 'हिंदी', englishName: 'Hindi', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'bn', nativeName: 'বাংলা', englishName: 'Bengali', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'ta', nativeName: 'தமிழ்', englishName: 'Tamil', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'te', nativeName: 'తెలుగు', englishName: 'Telugu', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'mr', nativeName: 'मराठी', englishName: 'Marathi', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'kn', nativeName: 'ಕನ್ನಡ', englishName: 'Kannada', flagEmoji: '🇮🇳'),
    LanguageInfo(code: 'gu', nativeName: 'ગુજરાતી', englishName: 'Gujarati', flagEmoji: '🇮🇳'),
  ];

  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = ref.read(localeProvider).languageCode;
  }

  void _onLanguageSelected(String code) {
    setState(() => _selectedCode = code);
    ref.read(localeProvider.notifier).setLocale(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header
              Text(
                l10n.selectLanguage,
                style: AppTextStyles.display.copyWith(fontSize: 26),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectLanguageSub,
                style: AppTextStyles.caption.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Grid of 8 Languages
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14.0,
                    crossAxisSpacing: 14.0,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selectedCode == lang.code;

                    return InkWell(
                      onTap: () => _onLanguageSelected(lang.code),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2.5 : 1.0,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lang.nativeName,
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 20,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang.englishName,
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Continue CTA
              AppButton(
                label: l10n.continueButton,
                onPressed: () {
                  context.push('/onboarding/welcome');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

