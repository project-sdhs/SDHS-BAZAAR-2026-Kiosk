import 'package:bazaar_kiosk/ui/components/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

double _opacity(WidgetTester tester) =>
    tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;

void main() {
  testWidgets('누르면 onTap 이 불린다', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(Pressable(onTap: () => taps++, child: const Text('1'))),
    );

    await tester.tap(find.text('1'));
    expect(taps, 1);
  });

  testWidgets('누르고 있는 동안만 투명도가 낮아진다', (tester) async {
    await tester.pumpWidget(
      _wrap(Pressable(onTap: () {}, child: const Text('1'))),
    );
    expect(_opacity(tester), 1);

    final gesture = await tester.startGesture(tester.getCenter(find.text('1')));
    await tester.pump();
    expect(_opacity(tester), 0.4);

    await gesture.up();
    await tester.pump();
    expect(_opacity(tester), 1);
  });

  testWidgets('onTap 이 없으면 눌러도 투명도가 그대로다', (tester) async {
    await tester.pumpWidget(_wrap(const Pressable(child: Text('1'))));

    final gesture = await tester.startGesture(tester.getCenter(find.text('1')));
    await tester.pump();
    expect(_opacity(tester), 1);
    await gesture.up();
  });

  testWidgets('내용이 작아도 터치 영역은 48 이상이다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Pressable(onTap: () {}, child: const SizedBox(width: 10, height: 10)),
      ),
    );

    final size = tester.getSize(find.byType(Pressable));
    expect(size.width, greaterThanOrEqualTo(Pressable.minTouchTarget));
    expect(size.height, greaterThanOrEqualTo(Pressable.minTouchTarget));
  });
}
