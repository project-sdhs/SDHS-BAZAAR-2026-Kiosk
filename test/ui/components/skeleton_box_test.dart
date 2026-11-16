import 'package:bazaar_kiosk/core/theme/app_colors.dart';
import 'package:bazaar_kiosk/ui/components/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('정한 크기의 placeholder 색 상자를 그린다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SkeletonBox(width: 254, height: 140)),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBox)), const Size(254, 140));
    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).last);
    expect((box.decoration as BoxDecoration).color, AppColors.placeholder);
  });

  testWidgets('width 를 안 주면 가로를 가득 채운다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(width: 300, child: SkeletonBox(height: 20)),
        ),
      ),
    );

    expect(tester.getSize(find.byType(SkeletonBox)).width, 300);
  });
}
