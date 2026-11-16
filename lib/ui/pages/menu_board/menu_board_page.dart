import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// 메뉴판 화면 (`/`).
///
/// 부스 태블릿에 띄워 두고 그 부스의 메뉴와 결제 QR 을 보여 주는 화면입니다.
/// 키오스크에서는 주문을 받지 않아요. 지금은 자리만 잡아 둔 상태(준비 중)입니다.
class MenuBoardPage extends StatelessWidget {
  const MenuBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('메뉴판', style: AppTypography.h1),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '준비 중',
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
