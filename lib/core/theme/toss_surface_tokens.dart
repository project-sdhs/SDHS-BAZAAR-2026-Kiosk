import 'package:flutter/material.dart';
import 'tds_tokens.dart';

/// [캡슐화] 그림자 없이 면(Surface)과 테두리(Border)로 계층을 나누는 디자인 토큰
class TossSurfaceTokens {
  TossSurfaceTokens._(); // 인스턴스화 방지

  // 색상 계층 (Layering Colors)
  static const Color canvas = Color(0xFFFFFFFF); // 기본 배경 및 3단계 흰 면
  static const Color surface = Color(0xFFF2F4F6); // 묶어야 할 블록 (카드, 타일)
  static const Color border = Color(0xFFE5E8EB); // 꼭 필요할 때만 쓰는 1줄 테두리

  // 강조 및 틴트 색상
  static const Color primaryBlue = TdsColors.primary;
  static const Color weakBlueBg =
      Color(0xFFEDF5FC); // 특별부스 / 안내 카드 / 첫 번째 아바타 틴트
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF4E5968);
  static const Color textTertiary = Color(0xFF8B95A1);

  // 카테고리 타일 규격 상수
  static const double tileBoxSize = 48.0;
  static const double tileRadius = 14.0;
  static const double tileGlyphSize = 24.0;
}
