import 'package:bazaar_kiosk/core/theme/app_colors.dart';
import 'package:bazaar_kiosk/ui/components/surface_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

BoxDecoration _decoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byType(SurfaceBox),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration
        as BoxDecoration;

void main() {
  testWidgets('기본은 surface 색에 테두리가 없다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SurfaceBox(child: Text('내용'))),
    );

    expect(find.text('내용'), findsOneWidget);
    expect(_decoration(tester).color, AppColors.surface);
    expect(_decoration(tester).border, isNull);
  });

  testWidgets('hasBorder 면 border 색 1px 테두리를 그린다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SurfaceBox(hasBorder: true, child: Text('내용'))),
    );

    final border = _decoration(tester).border! as Border;
    expect(border.top.color, AppColors.border);
    expect(border.top.width, 1);
  });
}
