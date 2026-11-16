// lib/tds/tds_tokens.dart
//
// 대응 표의 "우리 결정" 열을 그대로 옮긴 토큰 모음.
// 숫자를 바꿀 일이 생기면 이 파일만 고치면 된다.
import 'package:flutter/material.dart';

abstract final class TdsMetrics {
  // 본문 16 / 24
  static const double bodyFontSize = 16;
  static const double bodyLineHeight = 24;

  // 주 버튼 56 · r16 · 17/600
  static const double buttonHeight = 56;
  static const double buttonRadius = 16;
  static const double buttonFontSize = 17;
  static const FontWeight buttonFontWeight = FontWeight.w600;

  // 터치 타겟 48
  static const double minTouchTarget = 48;

  // 하단 탭: 4탭 + 가운데 QR 결제
  static const int tabCount = 4;
  static const double tabBarHeight = 56;
  static const double qrButtonSize = 48;

  // 경고창: TDS Dialog 한 벌 (정렬은 여기서 한 번만 정한다)
  static const TextAlign dialogTextAlign = TextAlign.center;
}

/// 제공된 파운데이션 스크린샷 기준 공통 색상.
abstract final class TdsColors {
  static const Color primary = Color(0xFF0171CE);
  static const Color onPrimary = Colors.white;
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF4E5968);
  static const Color divider = Color(0xFFF2F4F6);
  static const Color secondaryFill = Color(0xFFF2F4F6);
  static const Color danger = Color(0xFFE42939);
  static const Color disabledFill = Color(0xFFE5E8EB);
  static const Color disabledText = Color(0xFF8B95A1);
}

abstract final class TdsTypography {
  // 기준 폰트: Pretendard 한 벌 (pubspec.yaml에 등록 필요)
  static const String fontFamily = 'Pretendard';

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: TdsMetrics.bodyFontSize,
    height: TdsMetrics.bodyLineHeight / TdsMetrics.bodyFontSize,
    color: TdsColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: TdsMetrics.buttonFontSize,
    fontWeight: TdsMetrics.buttonFontWeight,
  );

  // 상단 바에는 제목이 없고, 제목은 본문 맨 위에 둔다.
  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: TdsColors.textPrimary,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
  );
}
