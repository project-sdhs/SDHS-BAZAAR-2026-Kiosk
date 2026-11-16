// lib/tds/tds_bottom_nav.dart
//
// 하단 탭: 4탭 + 가운데 QR 결제 버튼.
// 가장자리는 SafeArea가 홈 인디케이터/제스처 바 높이를 계산한다.
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon_view.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_pressable.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

class TdsTabItem {
  const TdsTabItem({required this.icon, required this.label});

  final TdsIcon icon;
  final String label;
}

class TdsBottomNav extends StatelessWidget {
  TdsBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onQrPressed,
  }) : assert(
          items.length == TdsMetrics.tabCount,
          '하단 탭은 ${TdsMetrics.tabCount}개여야 합니다.',
        );

  final List<TdsTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onQrPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // 그림자/tonal elevation 대신 얇은 선으로만 구분 (평면 레이어링)
      decoration: const BoxDecoration(
        color: TdsColors.surface,
        border: Border(top: BorderSide(color: TdsColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: TdsMetrics.tabBarHeight,
          child: Row(
            children: [
              _tab(0),
              _tab(1),
              Expanded(child: Center(child: _QrButton(onPressed: onQrPressed))),
              _tab(2),
              _tab(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(int index) {
    return Expanded(
      child: _TabButton(
        item: items[index],
        selected: index == currentIndex,
        onTap: () => onTabSelected(index),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final TdsTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? TdsColors.primary : TdsColors.textSecondary;
    return TdsPressable(
      expand: true,
      onTap: onTap,
      semanticLabel: item.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TdsIconView(item.icon, color: color),
          const SizedBox(height: 2),
          Text(item.label,
              style: TdsTypography.tabLabel.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _QrButton extends StatelessWidget {
  const _QrButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: TdsMetrics.qrButtonSize,
      height: TdsMetrics.qrButtonSize,
      child: TdsPressable(
        onTap: onPressed,
        enforceMinTarget: false,
        radius: BorderRadius.circular(TdsMetrics.qrButtonSize / 2),
        color: TdsColors.primary,
        semanticLabel: 'QR 결제',
        child: const Center(
          child: TdsIconView(TdsIcon.qrCode2, color: TdsColors.onPrimary),
        ),
      ),
    );
  }
}
