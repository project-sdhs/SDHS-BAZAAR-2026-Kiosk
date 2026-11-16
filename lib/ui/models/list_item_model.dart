import 'package:flutter/material.dart';

/// [추상화] 모든 리스트 행 데이터가 상속받는 추상 기본 클래스
abstract class TossListRowItem {
  final String title;
  final String subtitle;
  final IconData? icon;

  const TossListRowItem({
    required this.title,
    required this.subtitle,
    this.icon,
  });
}

/// 1. 부스/상품 정보형 모델 (예: 3-1 로제떡볶이 / 1,500원~)
class BoothRowItem extends TossListRowItem {
  final String priceText;
  final String orderCountText;
  final VoidCallback? onTap;

  const BoothRowItem({
    required super.title,
    required super.subtitle,
    required super.icon,
    required this.priceText,
    required this.orderCountText,
    this.onTap,
  });
}

/// 2. 단순 네비게이션형 모델 (예: 거래 내역 >)
class NavigationRowItem extends TossListRowItem {
  final VoidCallback onTap;

  const NavigationRowItem({
    required super.title,
    required super.subtitle,
    required super.icon,
    required this.onTap,
  });
}

/// 3. 토글 스위치형 모델 (예: 주문 알림 받기)
class ToggleRowItem extends TossListRowItem {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const ToggleRowItem({
    required super.title,
    super.subtitle = '',
    super.icon,
    required this.isEnabled,
    required this.onChanged,
  });
}
