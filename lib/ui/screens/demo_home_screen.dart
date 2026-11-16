import 'package:flutter/material.dart';
import 'navigation_demo_screen.dart';
import 'surface_demo_screen.dart';
import 'platform_demo_screen.dart';
import 'bazaar_screen.dart';

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('디지텍 바자회 · 컴포넌트 모음')),
        body: ListView(children: [
          _link(context, '상품 · 장바구니', const BazaarScreen()),
          _link(context, '내비게이션 · 검색 · 피드백', const BazaarDemoScreen()),
          _link(context, '표면 · 타일 · 상태', const SurfaceSystemDemoScreen()),
          _link(context, '플랫폼별 동작 · TDS 컴포넌트', const HomePage()),
        ]),
      );
  Widget _link(BuildContext context, String title, Widget page) => ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page)),
      );
}
