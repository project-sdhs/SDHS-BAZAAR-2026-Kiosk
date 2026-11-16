// lib/tds/tds_dialog.dart
//
// 경고창: iOS(가운데) / Android(왼쪽) 차이를 두지 않고 TDS Dialog 한 벌만 쓴다.
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_button.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

class TdsDialog extends StatelessWidget {
  const TdsDialog({
    super.key,
    required this.title,
    required this.actions,
    this.message,
  });

  final String title;
  final String? message;
  final List<Widget> actions;

  /// 확인/취소 다이얼로그. 확인이면 true, 취소면 false, 바깥을 누르면 null.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = '확인',
    String cancelLabel = '취소',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => TdsDialog(
        title: title,
        message: message,
        actions: [
          TdsButton(
            label: cancelLabel,
            variant: TdsButtonVariant.secondary,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          TdsButton(
            label: confirmLabel,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TdsColors.surface,
      elevation: 0, // 평면 레이어링
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TdsMetrics.dialogTextAlign,
              style: TdsTypography.body.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TdsMetrics.dialogTextAlign,
                style: TdsTypography.body.copyWith(
                  color: TdsColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: actions[i]),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
