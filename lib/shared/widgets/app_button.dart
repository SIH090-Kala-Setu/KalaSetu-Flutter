import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, accent, outlined, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 56.0, // Minimum 56px tap target
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.outlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildChild(context, AppColors.primary),
        ),
      );
    }

    if (variant == AppButtonVariant.text) {
      return SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildChild(context, AppColors.primary),
        ),
      );
    }

    Color bgColor = AppColors.primary;
    Color fgColor = AppColors.textOnPrimary;

    if (variant == AppButtonVariant.accent) {
      bgColor = AppColors.accent;
      fgColor = Colors.black87;
    } else if (variant == AppButtonVariant.danger) {
      bgColor = AppColors.error;
      fgColor = Colors.white;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(context, fgColor),
      ),
    );
  }

  Widget _buildChild(BuildContext context, Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.button.copyWith(color: color)),
        ],
      );
    }

    return Text(label, style: AppTextStyles.button.copyWith(color: color));
  }
}
