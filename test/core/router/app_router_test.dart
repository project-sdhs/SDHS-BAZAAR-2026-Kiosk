import 'package:bazaar_kiosk/core/router/app_router.dart';
import 'package:bazaar_kiosk/core/router/routes.dart';
import 'package:bazaar_kiosk/ui/pages/menu_board/menu_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('/ 경로는 메뉴판 화면이다', (tester) async {
    final router = createAppRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, Routes.menuBoard);
    expect(find.byType(MenuBoardPage), findsOneWidget);
  });

  testWidgets('없는 경로로 가면 메뉴판이 아닌 에러 화면이 보인다', (tester) async {
    final router = createAppRouter(initialLocation: '/does-not-exist');
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byType(MenuBoardPage), findsNothing);
  });
}
