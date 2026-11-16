import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// 묶어야 할 내용을 담는 면(surface) 상자.
///
/// 그림자 없이 색이 다른 면으로 계층을 나눕니다. 꼭 필요할 때만 [hasBorder] 로
/// 1px 테두리를 더해요.
class SurfaceBox extends StatelessWidget {
  const SurfaceBox({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.hasBorder = false,
    this.radius = AppRadius.r16,
    this.padding = const EdgeInsets.all(AppSpacing.s24),
  });

  final Widget child;
  final Color color;
  final bool hasBorder;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder ? Border.all(color: AppColors.border) : null,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
