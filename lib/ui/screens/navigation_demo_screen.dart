import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';
import 'package:flutter/material.dart';
import 'package:sdhs_bazaar_flutter/ui/models/list_item_model.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/navigation/toss_components.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/feedback/toss_feedback.dart';

class BazaarDemoScreen extends StatefulWidget {
  const BazaarDemoScreen({super.key});

  @override
  State<BazaarDemoScreen> createState() => _BazaarDemoScreenState();
}

class _BazaarDemoScreenState extends State<BazaarDemoScreen> {
  int _segmentIdx = 0;
  int _chipIdx = 0;
  bool _orderAlert = true;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    // 다형성을 활용한 리스트 데이터 구성
    final List<TossListRowItem> rows = [
      BoothRowItem(
        title: '3-1 로제떡볶이',
        subtitle: '본관 1층 로비',
        icon: Icons.ramen_dining,
        priceText: '1,500원~',
        orderCountText: '주문 128',
        onTap: () => TossFeedback.showToast(context, '10,000원이 충전됐어요'),
      ),
      NavigationRowItem(
        title: '거래 내역',
        subtitle: '충전 · 구매 기록',
        icon: Icons.receipt_long,
        onTap: () =>
            TossFeedback.showToast(context, '입금자명이 학번과 달라요', isError: true),
      ),
      ToggleRowItem(
        title: '주문 알림 받기',
        isEnabled: _orderAlert,
        onChanged: (val) => setState(() => _orderAlert = val),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TossTopHeader(
              title: '얼마를 충전할까요?',
              subtitle: '계좌이체하면 바로 크레딧이 들어와요',
            ),
            const SizedBox(height: 20),
            TossSearchField(
              hintText: '반 · 부스 · 메뉴 검색',
              onChanged: (query) => debugPrint('검색어: $query'),
            ),
            const SizedBox(height: 20),
            TossFilterGroup(
              segments: const ['학년 순', '인기 순'],
              selectedSegmentIndex: _segmentIdx,
              onSegmentChanged: (idx) => setState(() => _segmentIdx = idx),
              chips: const ['전체', '1학년', '2학년', '특별부스'],
              selectedChipIndex: _chipIdx,
              onChipChanged: (idx) => setState(() => _chipIdx = idx),
            ),
            const SizedBox(height: 16),
            // 구분선 없이 여백으로 끊는 리스트 행 렌더링
            ...rows.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TossListRowWidget(item: item),
                )),
            const SizedBox(height: 24),
            TossBottomCTA(
              secondaryText: '지도에서 보기',
              onSecondaryTap: () => TossFeedback.showBoothBottomSheet(
                context: context,
                headerTitle: '이 구역 부스 16곳',
                sortLabel: '거리순',
                content: TossListRowWidget(
                  item: BoothRowItem(
                    title: '2-3 타코야끼',
                    subtitle: '도보 1분 · 신관 2층 복도',
                    icon: Icons.fastfood,
                    priceText: '1,000원~',
                    orderCountText: '',
                  ),
                ),
              ),
              primaryText: 'QR로 결제',
              onPrimaryTap: () => TossFeedback.showConfirmDialog(
                context: context,
                title: '캐셔 권한을 줄까요?',
                description: '이재원 학생이 우리 반 부스에서 결제를 받을 수 있게 돼요.',
              ),
            ),
          ],
        ),
      ),
      // 가운데 QR 결제 버튼이 강조된 하단 탭 바
      bottomNavigationBar: BottomAppBar(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        elevation: 0,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, '홈'),
              _buildNavItem(1, Icons.storefront, '부스'),
              _buildCenterQrButton(),
              _buildNavItem(3, Icons.map_outlined, '지도'),
              _buildNavItem(4, Icons.person_outline, '마이'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.black87 : Colors.grey.shade400),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.black87 : Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildCenterQrButton() {
    return GestureDetector(
      onTap: () => TossFeedback.showToast(context, 'QR 결제 화면 실행'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: TdsColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.qr_code_scanner,
                color: Colors.white, size: 22),
          ),
          const SizedBox(height: 2),
          const Text('QR 결제',
              style: TextStyle(
                  fontSize: 11,
                  color: TdsColors.primary,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
