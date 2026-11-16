// lib/tds/tds_button.dart
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon_view.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_pressable.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

enum TdsButtonVariant {
  primary(TdsColors.primary, TdsColors.onPrimary),
  secondary(TdsColors.secondaryFill, TdsColors.textPrimary),
  danger(TdsColors.danger, TdsColors.onPrimary);

  const TdsButtonVariant(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// 주 버튼: 높이 56 · 반경 16 · 17/600
class TdsButton extends StatelessWidget {
  const TdsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TdsButtonVariant.primary,
    this.expanded = true,
  });

  final String label;

  /// null이면 비활성화
  final VoidCallback? onPressed;
  final TdsButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    final button = TdsPressable(
      onTap: onPressed,
      enforceMinTarget: false, // 56이라 이미 48 이상
      radius: BorderRadius.circular(TdsMetrics.buttonRadius),
      color: enabled ? variant.background : TdsColors.disabledFill,
      child: SizedBox(
        height: TdsMetrics.buttonHeight,
        child: Center(
          widthFactor: expanded ? null : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              label,
              style: TdsTypography.button.copyWith(
                color: enabled ? variant.foreground : TdsColors.disabledText,
              ),
            ),
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// 아이콘만 있는 버튼 (터치 타겟 48 보장)
class TdsIconButton extends StatelessWidget {
  const TdsIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.color = TdsColors.textPrimary,
  });

  final TdsIcon icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TdsPressable(
      onTap: onPressed,
      radius: BorderRadius.circular(TdsMetrics.minTouchTarget / 2),
      semanticLabel: semanticLabel,
      child: TdsIconView(icon, color: color),
    );
  }
}
