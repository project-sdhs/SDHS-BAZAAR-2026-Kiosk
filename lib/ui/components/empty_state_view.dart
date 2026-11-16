import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'surface_box.dart';

/// 보여줄 내용이 없을 때의 안내 (예: 아직 등록한 메뉴가 없을 때).
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.info_outline_rounded,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceBox(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s32,
        horizontal: AppSpacing.s24,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(title, style: AppTypography.h4, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
