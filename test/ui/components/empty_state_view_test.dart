import 'package:bazaar_kiosk/ui/components/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('제목과 설명을 보여준다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateView(
            title: '아직 메뉴가 없어요',
            description: '부스에서 메뉴를 등록하면 여기에 보여요',
          ),
        ),
      ),
    );

    expect(find.text('아직 메뉴가 없어요'), findsOneWidget);
    expect(find.text('부스에서 메뉴를 등록하면 여기에 보여요'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });
}
