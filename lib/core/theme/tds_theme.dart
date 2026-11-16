// lib/tds/tds_theme.dart
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

abstract final class TdsTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: TdsTypography.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TdsColors.primary,
        surface: TdsColors.surface,
      ).copyWith(
          primary: TdsColors.primary,
          onPrimary: TdsColors.onPrimary,
          error: TdsColors.danger),
      scaffoldBackgroundColor: TdsColors.surface,
      textTheme: const TextTheme(
        bodyLarge: TdsTypography.body,
        bodyMedium: TdsTypography.body,
      ),
      dividerColor: TdsColors.divider,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      // 누름 반응/라우트 전환은 platform 값에 따라 기본값을 그대로 쓴다.
    );
  }
}
