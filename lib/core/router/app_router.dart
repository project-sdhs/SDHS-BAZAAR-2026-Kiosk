import 'package:go_router/go_router.dart';

import '../../ui/pages/menu_board/menu_board_page.dart';
import 'routes.dart';

/// 앱의 라우터(go_router)를 만듭니다.
///
/// `app.dart` 에서 한 번 만들어 씁니다. 테스트에서는 `initialLocation` 으로
/// 원하는 화면에서 시작할 수 있어요.
GoRouter createAppRouter({String initialLocation = Routes.menuBoard}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.menuBoard,
        builder: (context, state) => const MenuBoardPage(),
      ),
    ],
  );
}
