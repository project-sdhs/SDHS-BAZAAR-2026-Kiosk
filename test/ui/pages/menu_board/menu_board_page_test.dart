import 'package:bazaar_kiosk/ui/pages/menu_board/menu_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('제목 "메뉴판"과 "준비 중" 문구를 보여준다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuBoardPage()));

    expect(find.text('메뉴판'), findsOneWidget);
    expect(find.text('준비 중'), findsOneWidget);
  });
}
