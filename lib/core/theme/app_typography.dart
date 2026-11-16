import 'package:flutter/painting.dart';

/// 타입 롤 6종 (디자인 기준 폰트: Pretendard).
///
/// 키오스크는 웹 빌드 용량을 줄이려고 폰트 파일을 넣지 않고 기기 기본 폰트를 씁니다.
/// (Pretendard 를 넣고 싶으면 App 레포처럼 `assets/fonts/` + pubspec 에 등록하면 돼요.)
///
/// 디자인의 `36 / 54` 는 글자 크기 36, 줄 높이 54 라는 뜻입니다.
/// Flutter 의 `height` 는 배수라서 `54 / 36` 처럼 나눠서 적습니다.
/// 자간 `-0.02em` 은 글자 크기에 곱한 값(px)으로 적습니다.
///
/// 글자 색은 넣지 않았습니다. 테마 기본색(foreground)을 쓰고,
/// 필요하면 `AppTypography.body.copyWith(color: AppColors.body)` 처럼 바꿉니다.
abstract final class AppTypography {
  /// 36 / 54 · 700
  static const TextStyle h1 = TextStyle(
    fontSize: 36,
    height: 54 / 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 36 * -0.02,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// 30 / 45 · 600
  static const TextStyle h2 = TextStyle(
    fontSize: 30,
    height: 45 / 30,
    fontWeight: FontWeight.w600,
    letterSpacing: 30 * -0.02,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// 24 / 36 · 600
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    height: 36 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 24 * -0.02,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// 22 / 33 · 600
  static const TextStyle h4 = TextStyle(
    fontSize: 22,
    height: 33 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 22 * -0.01,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// 16 / 24 · 400
  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// 14 / 21 · 400
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    height: 21 / 14,
    fontWeight: FontWeight.w400,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
