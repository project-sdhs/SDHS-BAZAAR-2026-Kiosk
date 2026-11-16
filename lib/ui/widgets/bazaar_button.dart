import 'package:flutter/material.dart';
import '../../core/theme/tds_tokens.dart';

enum BazaarButtonSize {
  small(32, 8),
  medium(38, 10),
  large(48, 14),
  xlarge(56, 16);

  const BazaarButtonSize(this.height, this.radius);
  final double height;
  final double radius;
}

class BazaarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final BazaarButtonSize size;
  const BazaarButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isLoading = false,
      this.size = BazaarButtonSize.large});
  @override
  Widget build(BuildContext context) => SizedBox(
        height: size.height,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: TdsColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                isLoading ? TdsColors.primary : TdsColors.secondaryFill,
            disabledForegroundColor:
                isLoading ? Colors.white : TdsColors.disabledText,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.radius)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (isLoading) ...[
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white)),
              const SizedBox(width: 8),
            ],
            Text(isLoading ? '확인 중' : label),
          ]),
        ),
      );
}
