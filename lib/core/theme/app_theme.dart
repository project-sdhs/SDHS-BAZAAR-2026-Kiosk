import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// 앱 전체 테마. `app.dart` 의 `MaterialApp.router(theme: AppTheme.light)` 에서 씁니다.
///
/// 디자인 원칙: 그림자 없음(평면 레이어링 — canvas 위에 surface, 필요하면 1px border),
/// 물결(ripple) 효과 없음.
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.weakBackground,
      onPrimaryContainer: AppColors.weakForeground,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
      errorContainer: AppColors.dangerWeak,
      onErrorContainer: AppColors.danger,
      surface: AppColors.canvas,
      onSurface: AppColors.foreground,
      onSurfaceVariant: AppColors.body,
      surfaceContainerHighest: AppColors.surface,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      shadow: Colors.transparent,
    );

    const textTheme = TextTheme(
      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      headlineSmall: AppTypography.h3,
      titleLarge: AppTypography.h4,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.bodySmall,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      // Toss 스타일: 누를 때 물결 효과 없음
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
