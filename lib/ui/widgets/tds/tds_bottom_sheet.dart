// lib/tds/tds_bottom_sheet.dart
//
// 선택 메뉴: iOS Action Sheet / Android Bottom Sheet 구분 없이 바텀시트 한 벌.
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon_view.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_pressable.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

class TdsSheetAction<T> {
  const TdsSheetAction({
    required this.label,
    required this.value,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final T value;
  final TdsIcon? icon;
  final bool destructive;
}

abstract final class TdsBottomSheet {
  /// 선택한 action의 value를 돌려준다. 닫으면 null.
  static Future<T?> show<T>(
    BuildContext context, {
    required List<TdsSheetAction<T>> actions,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TdsColors.surface,
      elevation: 0,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(title, style: TdsTypography.pageTitle),
              ),
            for (final action in actions)
              _SheetRow<T>(
                action: action,
                onTap: () => Navigator.of(sheetContext).pop(action.value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SheetRow<T> extends StatelessWidget {
  const _SheetRow({required this.action, required this.onTap});

  final TdsSheetAction<T> action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = action.destructive ? TdsColors.danger : TdsColors.textPrimary;

    return TdsPressable(
      expand: true,
      alignment: Alignment.centerLeft,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            if (action.icon != null) ...[
              TdsIconView(action.icon!, color: color),
              const SizedBox(width: 12),
            ],
            Text(action.label,
                style: TdsTypography.body.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
