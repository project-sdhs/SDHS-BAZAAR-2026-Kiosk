import 'package:flutter/material.dart';
import '../widgets/tds/tds.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  static const _items = [
    TdsTabItem(icon: TdsIcon.home, label: '홈'),
    TdsTabItem(icon: TdsIcon.storefront, label: '가맹점'),
    TdsTabItem(icon: TdsIcon.map, label: '지도'),
    TdsTabItem(icon: TdsIcon.person, label: '내 정보'),
  ];

  Future<void> _showDialog() async {
    final ok = await TdsDialog.confirm(
      context,
      title: '결제를 취소할까요?',
      message: '취소하면 되돌릴 수 없어요.',
    );
    debugPrint('dialog result: $ok');
  }

  Future<void> _showSheet() async {
    final picked = await TdsBottomSheet.show<String>(
      context,
      title: '정렬',
      actions: const [
        TdsSheetAction(label: '가까운 순', value: 'near', icon: TdsIcon.locationOn),
        TdsSheetAction(label: '인기 순', value: 'popular', icon: TdsIcon.search),
        TdsSheetAction(
            label: '삭제',
            value: 'delete',
            icon: TdsIcon.close,
            destructive: true),
      ],
    );
    debugPrint('sheet result: $picked');
  }

  void _openDetail() {
    Navigator.of(context).push(
      PlatformPolicy.of(context).buildRoute((_) => const DetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TdsScaffold(
      title: '홈',
      bottomNav: TdsBottomNav(
        items: _items,
        currentIndex: _tab,
        onTabSelected: (i) => setState(() => _tab = i),
        onQrPressed: () => debugPrint('QR 결제'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TdsButton(label: '경고창 열기', onPressed: _showDialog),
            const SizedBox(height: 12),
            TdsButton(
              label: '선택 메뉴 열기',
              variant: TdsButtonVariant.secondary,
              onPressed: _showSheet,
            ),
            const SizedBox(height: 12),
            TdsButton(label: '상세로 이동', onPressed: _openDetail),
            const SizedBox(height: 12),
            const TdsButton(label: '비활성 버튼', onPressed: null),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TdsScaffold(
      title: '상세',
      showBack: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          '엣지 스와이프(iOS)와 시스템 백(Android) 둘 다 동작합니다.',
          style: TdsTypography.body,
        ),
      ),
    );
  }
}
