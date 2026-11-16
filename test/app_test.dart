import 'package:bazaar_kiosk/app.dart';
import 'package:bazaar_kiosk/ui/pages/menu_board/menu_board_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('앱을 켜면 메뉴판 화면이 보인다', (tester) async {
    await tester.pumpWidget(const BazaarKioskApp());
    await tester.pumpAndSettle();

    expect(find.byType(MenuBoardPage), findsOneWidget);
    expect(find.text('메뉴판'), findsOneWidget);
  });
}
