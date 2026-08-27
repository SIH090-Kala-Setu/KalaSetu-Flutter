import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: AppTextStyles.caption.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: buttonLabel!,
                onPressed: onButtonPressed,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
