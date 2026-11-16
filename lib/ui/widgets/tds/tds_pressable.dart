// lib/tds/tds_pressable.dart
//
// 눌리는 모든 것의 기반 위젯.
// - 터치 타겟 최소 48 보장
// - 누름 반응은 플랫폼 정책에 위임
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/core/platform/platform_policy.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

class TdsPressable extends StatelessWidget {
  const TdsPressable({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.color,
    this.semanticLabel,
    this.enforceMinTarget = true,
    this.expand = false,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final Color? color;
  final String? semanticLabel;

  /// false면 48 최소 크기 보정을 하지 않는다 (이미 크기가 정해진 버튼용).
  final bool enforceMinTarget;

  /// true면 가로를 가득 채운다 (리스트 행용).
  final bool expand;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final policy = PlatformPolicy.of(context);

    Widget content = child;
    if (enforceMinTarget) {
      content = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: TdsMetrics.minTouchTarget,
          minHeight: TdsMetrics.minTouchTarget,
        ),
        child: Align(
          alignment: alignment,
          widthFactor: expand ? null : 1,
          heightFactor: 1,
          child: child,
        ),
      );
    }

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: policy.pressFeedback.wrap(
        child: content,
        onTap: onTap,
        radius: radius,
        color: color,
      ),
    );
  }
}
