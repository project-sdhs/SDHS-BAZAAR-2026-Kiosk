import 'package:bazaar_kiosk/core/theme/app_colors.dart';
import 'package:bazaar_kiosk/core/theme/app_theme.dart';
import 'package:bazaar_kiosk/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Primary 는 디지텍 블루(#0171CE)다', () {
    expect(AppColors.primary, const Color(0xFF0171CE));
    expect(AppTheme.light.colorScheme.primary, AppColors.primary);
  });

  test('화면 배경은 canvas(흰색)이고 그림자 색은 투명하다', () {
    final theme = AppTheme.light;

    expect(theme.scaffoldBackgroundColor, AppColors.canvas);
    expect(theme.colorScheme.shadow, Colors.transparent);
  });

  test('타입 롤의 줄 높이가 디자인 값과 같다', () {
    double lineHeight(TextStyle style) => style.fontSize! * style.height!;

    expect(lineHeight(AppTypography.h1), 54);
    expect(lineHeight(AppTypography.h2), 45);
    expect(lineHeight(AppTypography.h3), 36);
    expect(lineHeight(AppTypography.h4), 33);
    expect(lineHeight(AppTypography.body), 24);
    expect(lineHeight(AppTypography.bodySmall), 21);
  });
}
