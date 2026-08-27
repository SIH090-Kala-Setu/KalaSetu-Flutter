import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'Artisan';

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
        title: Text(l10n.whoAreYou),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectRoleSub,
                style: AppTextStyles.caption.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 24),
              // Role 1: Artisan
              _buildRoleCard(
                role: 'Artisan',
                title: l10n.roleArtisan,
                description: l10n.roleArtisanDesc,
                icon: Icons.palette_outlined,
                emoji: '🧵',
              ),
              const SizedBox(height: 16),
              // Role 2: Aggregator
              _buildRoleCard(
                role: 'Aggregator',
                title: l10n.roleAggregator,
                description: l10n.roleAggregatorDesc,
                icon: Icons.groups_outlined,
                emoji: '🏘️',
              ),
              const SizedBox(height: 16),
              // Role 3: Buyer
              _buildRoleCard(
                role: 'Buyer',
                title: l10n.roleBuyer,
                description: l10n.roleBuyerDesc,
                icon: Icons.storefront_outlined,
                emoji: '🛍️',
              ),
              const Spacer(),
              // Confirm & Proceed
              AppButton(
                label: l10n.continueButton,
                onPressed: () {
                  context.push('/onboarding/phone?role=$_selectedRole');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
    required String emoji,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.background,
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 18,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textDisabled,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

