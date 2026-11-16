import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// 불러오는 동안 내용 자리를 잡아 두는 회색 상자 (스켈레톤).
///
/// 예: 메뉴 카드 사진 자리 `SkeletonBox(width: 254, height: 140)`
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = AppRadius.r8,
  });

  /// null 이면 가로를 가득 채웁니다.
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.placeholder,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
