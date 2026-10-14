/// 화면 주소(path) 상수.
///
/// 주소 문자열을 화면 코드에 직접 쓰지 말고 `context.go(Routes.menuBoard)` 처럼 씁니다.
/// 새 화면을 만들면 여기에 주소를 추가하고 `app_router.dart` 에 GoRoute 를 등록하세요.
abstract final class Routes {
  /// 메뉴판 (첫 화면)
  static const String menuBoard = '/';
}
