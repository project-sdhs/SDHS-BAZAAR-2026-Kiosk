// lib/tds/tds_scaffold.dart
//
// 상단 바: 뒤로가기만 둔다. 제목은 상단 바가 아니라 본문 맨 위에 그린다.
// 가장자리: SafeArea로 계산. 깊이: elevation 0.
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_bottom_nav.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/tds/tds_button.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';
import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';

class TdsScaffold extends StatelessWidget {
  const TdsScaffold({
    super.key,
    required this.body,
    this.title,
    this.showBack = false,
    this.bottomNav,
  });

  final Widget body;
  final String? title;
  final bool showBack;
  final TdsBottomNav? bottomNav;

  @override
  Widget build(BuildContext context) {
    final appBar = showBack
        ? AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: TdsColors.surface,
            leadingWidth: 64,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TdsIconButton(
                  icon: TdsIcon.arrowBackIosNew,
                  semanticLabel: '뒤로가기',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          )
        : null;

    return Scaffold(
      backgroundColor: TdsColors.surface,
      appBar: appBar,
      bottomNavigationBar: bottomNav,
      body: SafeArea(
        top: appBar == null,
        bottom: bottomNav == null, // 탭이 있으면 탭이 하단 inset을 처리
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Text(title!, style: TdsTypography.pageTitle),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
