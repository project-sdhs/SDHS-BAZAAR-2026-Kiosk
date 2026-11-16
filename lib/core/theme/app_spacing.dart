/// 간격 토큰 4 · 6 · 8 · 16 · 24 · 32.
///
/// 이름의 숫자가 곧 px 값입니다. 예: `EdgeInsets.all(AppSpacing.s24)`
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;

  /// 화면 좌우 기본 여백 (태블릿이라 휴대폰 앱보다 넓게)
  static const double screenHorizontal = s32;
}

/// 모서리 둥글기 토큰 4 · 6 · 8 · 10 · 14 · 16.
///
/// 예: `BorderRadius.circular(AppRadius.r16)`
abstract final class AppRadius {
  static const double r4 = 4;
  static const double r6 = 6;
  static const double r8 = 8;
  static const double r10 = 10;
  static const double r14 = 14;
  static const double r16 = 16;
}
