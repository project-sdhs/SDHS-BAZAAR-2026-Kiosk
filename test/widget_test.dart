import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdhs_bazaar_flutter/app.dart';

void main() {
  testWidgets('홈에서 상품 화면을 열고 담기와 삭제를 수행한다', (tester) async {
    await tester.pumpWidget(const BazaarApp());
    await tester.tap(find.text('상품 · 장바구니'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('담기').first);
    await tester.pump();
    expect(find.text('총금액: 3000원'), findsOneWidget);
    await tester.tap(find.byTooltip('상품 삭제'));
    await tester.pump();
    expect(find.text('총금액: 0원'), findsOneWidget);
  });
  testWidgets('통합된 모든 데모 화면이 렌더링된다', (tester) async {
    for (final title in [
      '내비게이션 · 검색 · 피드백',
      '표면 · 타일 · 상태',
      '플랫폼별 동작 · TDS 컴포넌트'
    ]) {
      await tester.pumpWidget(BazaarApp(key: UniqueKey()));
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: title);
    }
  });
}
