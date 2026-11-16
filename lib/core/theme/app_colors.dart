import 'package:flutter/painting.dart';

/// 디자인 캔버스(Toss Design System 기반)의 색상 토큰.
///
/// 화면에서 색을 직접 쓰지 말고 `AppColors.primary`처럼 여기 값을 써 주세요.
abstract final class AppColors {
  // 브랜드 (Primary = 디지텍 퍼스널 컬러)
  static const Color primary = Color(0xFF0171CE);
  static const Color primaryPressed = Color(0xFF015CA8);
  static const Color weakBackground = Color(0xFFEDF5FC);
  static const Color weakForeground = Color(0xFF01477F);
  static const Color tileTint = Color(0xFFD4E7F7);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // 중성색 (TDS)
  static const Color foreground = Color(0xFF191F28);
  static const Color body = Color(0xFF4E5968);
  static const Color muted = Color(0xFF8B95A1);
  static const Color border = Color(0xFFE5E8EB);
  static const Color surface = Color(0xFFF2F4F6);
  static const Color canvas = Color(0xFFFFFFFF);

  // 상태
  static const Color danger = Color(0xFFE42939);
  static const Color dangerWeak = Color(0xFFFDECEE);
  static const Color focusRing = Color(0xFFA9CFEF);
  static const Color placeholder = Color(0xFFE9ECF0);
}
