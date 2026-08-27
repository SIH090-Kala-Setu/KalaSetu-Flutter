import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'verified':
      case 'completed':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        break;
      case 'pending':
      case 'pending review':
      case 'draft':
      case 'upcoming':
        bg = AppColors.warning.withValues(alpha: 0.18);
        fg = const Color(0xFFD68910);
        break;
      case 'sold out':
      case 'cancelled':
      case 'archived':
      case 'declined':
      case 'rejected':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.primary.withValues(alpha: 0.1);
        fg = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

