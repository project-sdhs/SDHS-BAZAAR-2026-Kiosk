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

    // 주소는 그대로 두고 go_router 기본 에러 화면(Page Not Found)을 보여 준다.
    // (errorBuilder 로 직접 만든 에러 화면을 붙이면 이 테스트도 같이 바꿉니다.)
    expect(router.routeInformationProvider.value.uri.path, '/does-not-exist');
    expect(find.byType(MenuBoardPage), findsNothing);
    expect(find.text('Page Not Found'), findsOneWidget);
    expect(
      find.text('GoException: no routes for location: /does-not-exist'),
      findsOneWidget,
    );

    // 에러 화면의 홈 버튼을 누르면 메뉴판(/)으로 돌아간다.
    await tester.tap(find.text('Go to home page'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, Routes.menuBoard);
    expect(find.byType(MenuBoardPage), findsOneWidget);
  });
}
