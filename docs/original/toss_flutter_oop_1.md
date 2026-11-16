# Toss 스타일 Flutter UI 컴포넌트 및 객체지향(OOP) 설계

제시된 디자인 시스템 시안(`COMPONENTS · 02 내비게이션과 검색`)을 바탕으로, 객체지향 설계 원칙(추상화, 상속, 다형성, 캡슐화, 단일 책임 원칙)을 적용한 Dart/Flutter 구현 코드입니다.

---

## 1. 객체지향 아키텍처 (폴더 구조)

데이터(Model)와 UI 컴포넌트(Widget), 피드백 유틸리티를 명확히 분리하여 유지보수성과 재사용성을 높였습니다.

```text
lib/
├── models/                 # [캡슐화 & 추상화] 데이터 모델 계층
│   └── list_item_model.dart
├── widgets/                # [재사용성 & 합성] 디자인 시스템 UI 컴포넌트
│   ├── toss_components.dart
│   └── toss_feedback.dart
└── main.dart               # 조립 및 실행 화면
```

---

## 2. 핵심 객체지향 적용 포인트

* **추상화 (Abstraction):** `TossListRowItem` 추상 클래스를 통해 리스트 항목의 공통 속성(`title`, `subtitle`, `icon`)을 정의했습니다.
* **상속과 다형성 (Inheritance & Polymorphism):** `BoothRowItem`, `NavigationRowItem`, `ToggleRowItem`이 부모 클래스를 상속받고, `TossListRowWidget`은 런타임 타입(Dart 3 패턴 매칭)에 따라 각기 다른 UI를 렌더링합니다.
* **단일 책임 원칙 (SRP):** 검색창의 포커스/텍스트 제어(`TossSearchField`), 피드백 알림(`TossFeedback`), 하단 액션(`TossBottomCTA`)을 독립된 객체로 캡슐화했습니다.

---

## 3. 전체 소스 코드

### ① `lib/models/list_item_model.dart` (데이터 모델 계층)

```dart
import 'package:flutter/material.dart';

/// [추상화] 모든 리스트 행 데이터가 상속받는 추상 기본 클래스
abstract class TossListRowItem {
  final String title;
  final String subtitle;
  final IconData? icon;

  const TossListRowItem({
    required this.title,
    required this.subtitle,
    this.icon,
  });
}

/// 1. 부스/상품 정보형 모델 (예: 3-1 로제떡볶이 / 1,500원~)
class BoothRowItem extends TossListRowItem {
  final String priceText;
  final String orderCountText;
  final VoidCallback? onTap;

  const BoothRowItem({
    required super.title,
    required super.subtitle,
    required super.icon,
    required this.priceText,
    required this.orderCountText,
    this.onTap,
  });
}

/// 2. 단순 네비게이션형 모델 (예: 거래 내역 >)
class NavigationRowItem extends TossListRowItem {
  final VoidCallback onTap;

  const NavigationRowItem({
    required super.title,
    required super.subtitle,
    required super.icon,
    required this.onTap,
  });
}

/// 3. 토글 스위치형 모델 (예: 주문 알림 받기)
class ToggleRowItem extends TossListRowItem {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const ToggleRowItem({
    required super.title,
    super.subtitle = '',
    super.icon,
    required this.isEnabled,
    required this.onChanged,
  });
}
```

### ② `lib/widgets/toss_components.dart` (UI 컴포넌트 계층)

```dart
import 'package:flutter/material.dart';
import '../models/list_item_model.dart';

/// 1. 상단 바 + 큰 제목 (가운데 정렬 타이틀을 쓰지 않는 토스 스타일)
class TossTopHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const TossTopHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: onBack ?? () => Navigator.maybePop(context),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}

/// 2. 검색 필드 (포커스 상태에 따른 테두리 변경 & 초기화 버튼 캡슐화)
class TossSearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const TossSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<TossSearchField> createState() => _TossSearchFieldState();
}

class _TossSearchFieldState extends State<TossSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? const Color(0xFF3182F6) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (val) {
          setState(() {});
          widget.onChanged(val);
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.cancel, color: Colors.grey.shade400, size: 20),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

/// 3. 세그먼티드 컨트롤 & 필터 칩
class TossFilterGroup extends StatelessWidget {
  final List<String> segments;
  final int selectedSegmentIndex;
  final ValueChanged<int> onSegmentChanged;
  final List<String> chips;
  final int selectedChipIndex;
  final ValueChanged<int> onChipChanged;

  const TossFilterGroup({
    super.key,
    required this.segments,
    required this.selectedSegmentIndex,
    required this.onSegmentChanged,
    required this.chips,
    required this.selectedChipIndex,
    required this.onChipChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 세그먼티드 탭
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: List.generate(segments.length, (index) {
              final isSelected = index == selectedSegmentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSegmentChanged(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      segments[index],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.black87 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // 필터 칩
        Wrap(
          spacing: 8,
          children: List.generate(chips.length, (index) {
            final isSelected = index == selectedChipIndex;
            return ChoiceChip(
              label: Text(chips[index]),
              selected: isSelected,
              onSelected: (_) => onChipChanged(index),
              selectedColor: const Color(0xFF191F28),
              backgroundColor: const Color(0xFFF2F4F6),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              showCheckmark: false,
            );
          }),
        ),
      ],
    );
  }
}

/// 4. [다형성 적용] 모델 타입에 따라 다르게 렌더링되는 리스트 행 위젯
class TossListRowWidget extends StatelessWidget {
  final TossListRowItem item;

  const TossListRowWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 패턴 매칭(Dart 3)을 통해 자식 클래스별 UI 분기 처리
    return switch (item) {
      BoothRowItem booth => ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: booth.onTap,
          leading: _buildIconBox(booth.icon),
          title: Text(booth.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(booth.subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(booth.priceText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(booth.orderCountText, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
      NavigationRowItem nav => ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: nav.onTap,
          leading: _buildIconBox(nav.icon),
          title: Text(nav.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(nav.subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ToggleRowItem toggle => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: toggle.isEnabled,
          onChanged: toggle.onChanged,
          activeColor: const Color(0xFF3182F6),
          title: Text(toggle.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildIconBox(IconData? icon) {
    if (icon == null) return const SizedBox.shrink();
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.grey.shade700),
    );
  }
}

/// 5. BottomCTA (하단 고정 듀얼 버튼)
class TossBottomCTA extends StatelessWidget {
  final String secondaryText;
  final VoidCallback onSecondaryTap;
  final String primaryText;
  final VoidCallback onPrimaryTap;

  const TossBottomCTA({
    super.key,
    required this.secondaryText,
    required this.onSecondaryTap,
    required this.primaryText,
    required this.onPrimaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onSecondaryTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8F3FF),
                foregroundColor: const Color(0xFF3182F6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(secondaryText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onPrimaryTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(primaryText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
```

### ③ `lib/widgets/toss_feedback.dart` (다이얼로그 · 토스트 · 바텀시트)

```dart
import 'package:flutter/material.dart';

class TossFeedback {
  /// 다이얼로그 (예: 캐셔 권한을 줄까요?)
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String description,
    String cancelText = '취소',
    String confirmText = '권한 주기',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F4F6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(cancelText, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3182F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(confirmText, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 토스트 메시지 (성공/경고 상태 지원)
  static void showToast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFFFEEEE) : const Color(0xFF191F28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: isError ? const Color(0xFFF04452) : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: TextStyle(
                color: isError ? const Color(0xFFF04452) : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 바텀시트 (예: 이 구역 부스 16곳)
  static void showBoothBottomSheet({
    required BuildContext context,
    required String headerTitle,
    required String sortLabel,
    required Widget content,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(headerTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(sortLabel, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
```

### ④ `lib/main.dart` (전체 컴포넌트 조립 및 실행)

```dart
import 'package:flutter/material.dart';
import 'models/list_item_model.dart';
import 'widgets/toss_components.dart';
import 'widgets/toss_feedback.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BazaarDemoScreen(),
    ));

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
        onTap: () => TossFeedback.showToast(context, '입금자명이 학번과 달라요', isError: true),
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
        color: Colors.white,
        elevation: 8,
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
          Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black87 : Colors.grey.shade500)),
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
            decoration: const BoxDecoration(color: Color(0xFF3182F6), shape: BoxShape.circle),
            child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 2),
          const Text('QR 결제', style: TextStyle(fontSize: 11, color: Color(0xFF3182F6), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```
