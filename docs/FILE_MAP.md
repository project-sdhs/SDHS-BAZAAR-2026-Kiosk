# 원본 → 정리된 파일 대응표

| 제공 자료 / 원래 위치 | 정리된 위치 |
|---|---|
| toss_flutter_oop (1).md → lib/models/list_item_model.dart | lib/ui/models/list_item_model.dart |
| toss_flutter_oop (1).md → lib/widgets/toss_components.dart | lib/ui/widgets/navigation/toss_components.dart |
| toss_flutter_oop (1).md → lib/widgets/toss_feedback.dart | lib/ui/widgets/feedback/toss_feedback.dart |
| toss_flutter_oop (1).md → lib/main.dart | lib/ui/screens/navigation_demo_screen.dart |
| toss_flutter_oop (2).md → lib/theme/toss_surface_tokens.dart | lib/core/theme/toss_surface_tokens.dart |
| toss_flutter_oop (2).md → lib/models/category_model.dart | lib/ui/models/category_model.dart |
| toss_flutter_oop (2).md → lib/widgets/toss_surface_components.dart | lib/ui/widgets/surface/toss_surface_components.dart |
| toss_flutter_oop (2).md → lib/main.dart | lib/ui/screens/surface_demo_screen.dart |
| tds_flutter.zip → lib/tds/platform_policy.dart | lib/core/platform/platform_policy.dart |
| tds_flutter.zip → lib/tds/press_feedback.dart | lib/core/platform/press_feedback.dart |
| tds_flutter.zip → lib/tds/tds.dart | lib/ui/widgets/tds/tds.dart |
| tds_flutter.zip → lib/tds/tds_bottom_nav.dart | lib/ui/widgets/tds/tds_bottom_nav.dart |
| tds_flutter.zip → lib/tds/tds_bottom_sheet.dart | lib/ui/widgets/tds/tds_bottom_sheet.dart |
| tds_flutter.zip → lib/tds/tds_button.dart | lib/ui/widgets/tds/tds_button.dart |
| tds_flutter.zip → lib/tds/tds_dialog.dart | lib/ui/widgets/tds/tds_dialog.dart |
| tds_flutter.zip → lib/tds/tds_icon.dart | lib/ui/icons/tds_icon.dart |
| tds_flutter.zip → lib/tds/tds_icon_view.dart | lib/ui/icons/tds_icon_view.dart |
| tds_flutter.zip → lib/tds/tds_pressable.dart | lib/ui/widgets/tds/tds_pressable.dart |
| tds_flutter.zip → lib/tds/tds_scaffold.dart | lib/ui/widgets/tds/tds_scaffold.dart |
| tds_flutter.zip → lib/tds/tds_theme.dart | lib/core/theme/tds_theme.dart |
| tds_flutter.zip → lib/tds/tds_tokens.dart | lib/core/theme/tds_tokens.dart |
| tds_flutter.zip → lib/main.dart | lib/ui/screens/platform_demo_screen.dart |
| 문서 (2)의 AsyncViewState 계층 | lib/state/async_view_state.dart |
| 앞서 채팅으로 제공한 Product / CartItem / Seller | lib/data/models/ |
| 앞서 채팅으로 제공한 Cart | lib/state/cart.dart |
| 앞서 채팅으로 제공한 BazaarButton | lib/ui/widgets/bazaar_button.dart |
| 앞서 채팅으로 제공한 BazaarScreen | lib/ui/screens/bazaar_screen.dart |
| 앞서 채팅으로 제안한 ProductCard | lib/ui/widgets/product_card.dart |
| 앞서 채팅의 AppColors / appTheme | lib/core/theme/tds_tokens.dart 및 tds_theme.dart로 통합 |

새로 추가한 연결 파일: app.dart, demo_home_screen.dart, product_repository.dart, test/.
원본 문서의 서로 다른 main() 세 개를 데모 화면으로 분리하고 main.dart 하나로 연결했습니다.
UI 아이콘과 콜백을 포함한 리스트/카테고리 모델은 순수 데이터 모델과 구분해 ui/models에 두었습니다.
이전 JavaScript 예시는 사용자가 Dart로 변경 요청한 뒤의 Dart 클래스로 대체했습니다.
