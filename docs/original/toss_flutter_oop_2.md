# Toss 스타일 Flutter UI 컴포넌트 (03. 표면 · 타일 · 상태) 및 객체지향(OOP) 설계

제시된 디자인 시스템 시안(`COMPONENTS · 03 표면 · 타일 · 상태`)을 바탕으로, **"그림자 없이 색상 계층(`canvas #FFFFFF` → `surface #F2F4F6`)과 1px 테두리(`border #E5E8EB`)로만 깊이를 표현한다"**는 규칙을 객체지향 설계 원칙(캡슐화, 합성, 다형성, Sealed Class 상태 추상화)으로 구현한 Dart/Flutter 코드입니다.

## 1. 객체지향 아키텍처 (폴더 구조)

```text
lib/
├── theme/                  # [캡슐화] 디자인 토큰 (색상 계층 및 규격 상수)
│   └── toss_surface_tokens.dart
├── models/                 # [추상화 & 다형성] 카테고리, 유저 아바타, 비동기 UI 상태
│   └── category_model.dart
├── widgets/                # [재사용성 & 합성] 표면 · 타일 · 상태 컴포넌트
│   └── toss_surface_components.dart
└── main.dart               # 조립 및 실행 화면
```

## 2. 핵심 객체지향 적용 포인트

* **캡슐화 (Encapsulation):**
  * `TossSurfaceTokens` 클래스로 색상 계층(`canvas`, `surface`, `border`)과 규격(48/r14/24)을 단일 진실 공급원(SSOT)으로 관리합니다.
  * `StudentAvatarModel` 내부에서 이름 문자열로부터 첫 글자(성)를 추출하는 `initial` getter를 캡슐화하여 UI 위젯이 문자열 파싱 로직을 알지 못하게 분리했습니다.
* **합성 (Composition):** 그림자 없는 컨테이너 규칙을 가진 `TossSurfaceBox`를 기본 단위로 만들고, `TossCreditCard`, `TossNoticeCard`, `TossEmptyStateView`, `TossLayeringRuleCard`가 이를 합성하여 일관된 디자인 규칙을 강제합니다.
* **다형성과 대수적 자료형 (Polymorphism & Sealed Class):** `AsyncViewState<T>`를 `LoadingState`, `EmptyState`, `DataState`로 모델링하여 로딩 중일 때는 스켈레톤을, 데이터가 없을 때는 빈 상태를, 응답 완료 시에는 카테고리 타일을 안전하게 렌더링합니다.

## 3. 전체 소스 코드

### ① `lib/theme/toss_surface_tokens.dart` (디자인 토큰 캡슐화)

```dart
import 'package:flutter/material.dart';

/// [캡슐화] 그림자 없이 면(Surface)과 테두리(Border)로 계층을 나누는 디자인 토큰
class TossSurfaceTokens {
  TossSurfaceTokens._(); // 인스턴스화 방지

  // 색상 계층 (Layering Colors)
  static const Color canvas = Color(0xFFFFFFFF);      // 기본 배경 및 3단계 흰 면
  static const Color surface = Color(0xFFF2F4F6);     // 묶어야 할 블록 (카드, 타일)
  static const Color border = Color(0xFFE5E8EB);      // 꼭 필요할 때만 쓰는 1줄 테두리

  // 강조 및 틴트 색상
  static const Color primaryBlue = Color(0xFF3182F6);
  static const Color weakBlueBg = Color(0xFFE8F3FF);  // 특별부스 / 안내 카드 / 첫 번째 아바타 틴트
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF4E5968);
  static const Color textTertiary = Color(0xFF8B95A1);

  // 카테고리 타일 규격 상수
  static const double tileBoxSize = 48.0;
  static const double tileRadius = 14.0;
  static const double tileGlyphSize = 24.0;
}
```

### ② `lib/models/category_model.dart` (도메인 모델 및 상태 계층)

```dart
import 'package:flutter/material.dart';

/// 카테고리 타일 도메인 모델
class CategoryItem {
  final String label;
  final IconData icon;
  final bool isHighlighted; // 특별부스 등 weak 틴트 적용 여부

  const CategoryItem({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
  });
}

/// 아바타 도메인 모델 (프로필 사진 없이 성(첫 글자)만 추출하는 로직 캡슐화)
class StudentAvatarModel {
  final String fullName;
  final bool isHighlighted;

  const StudentAvatarModel({
    required this.fullName,
    this.isHighlighted = false,
  });

  /// 이름에서 첫 글자(성)를 안전하게 추출하는 Getter
  String get initial => fullName.isNotEmpty ? fullName.characters.first : '?';
}

/// [추상화 & 다형성] 비동기 데이터 로딩 상태 계층 (스켈레톤 -> 데이터 or 빈 상태)
sealed class AsyncViewState<T> {
  const AsyncViewState();
}

class LoadingState<T> extends AsyncViewState<T> {
  const LoadingState();
}

class EmptyState<T> extends AsyncViewState<T> {
  final String title;
  final String description;
  const EmptyState({required this.title, required this.description});
}

class DataState<T> extends AsyncViewState<T> {
  final T data;
  const DataState(this.data);
}
```

### ③ `lib/widgets/toss_surface_components.dart` (표면 · 타일 · 상태 위젯)

```dart
import 'package:flutter/material.dart';
import '../theme/toss_surface_tokens.dart';
import '../models/category_model.dart';

/// 1. 기본 Surface 컨테이너 (그림자 0, 선택적 1px 테두리)
class TossSurfaceBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool hasBorder;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const TossSurfaceBox({
    super.key,
    required this.child,
    this.color = TossSurfaceTokens.surface,
    this.hasBorder = false,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: TossSurfaceTokens.border, width: 1)
            : null,
      ),
      child: child,
    );
  }
}

/// 2. 카테고리 타일 (48x48 / r14 / 글리프 24 / weak 틴트 지원)
class TossCategoryTile extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback? onTap;

  const TossCategoryTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = item.isHighlighted
        ? TossSurfaceTokens.weakBlueBg
        : TossSurfaceTokens.surface;
    final iconColor = item.isHighlighted
        ? TossSurfaceTokens.primaryBlue
        : TossSurfaceTokens.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: TossSurfaceTokens.tileBoxSize,
            height: TossSurfaceTokens.tileBoxSize,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(TossSurfaceTokens.tileRadius),
            ),
            child: Icon(
              item.icon,
              size: TossSurfaceTokens.tileGlyphSize,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TossSurfaceTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. 카드 컴포넌트 (보유 크레딧 카드 & 안내 배너 카드)
class TossCreditCard extends StatelessWidget {
  final String formattedBalance;
  final VoidCallback onChargeTap;
  final VoidCallback onQrPayTap;

  const TossCreditCard({
    super.key,
    required this.formattedBalance,
    required this.onChargeTap,
    required this.onQrPayTap,
  });

  @override
  Widget build(BuildContext context) {
    return TossSurfaceBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보유 크레딧',
            style: TextStyle(fontSize: 13, color: TossSurfaceTokens.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                formattedBalance,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: TossSurfaceTokens.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFFFFB800),
                child: Text('C', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onChargeTap,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('충전하기', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossSurfaceTokens.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onQrPayTap,
                  icon: const Icon(Icons.qr_code_2, size: 18),
                  label: const Text('QR 결제', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossSurfaceTokens.canvas,
                    foregroundColor: TossSurfaceTokens.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 안내 틴트 카드 (입금자명을 이렇게 보내주세요)
class TossNoticeCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const TossNoticeCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return TossSurfaceBox(
      color: TossSurfaceTokens.weakBlueBg,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B64DA),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: TossSurfaceTokens.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// 4. 텍스트 아바타 (프로필 사진을 받지 않고 성만 표시)
class TossTextAvatar extends StatelessWidget {
  final StudentAvatarModel student;

  const TossTextAvatar({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: student.isHighlighted
              ? TossSurfaceTokens.weakBlueBg
              : TossSurfaceTokens.surface,
          child: Text(
            student.initial,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: student.isHighlighted
                  ? TossSurfaceTokens.primaryBlue
                  : TossSurfaceTokens.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          student.fullName,
          style: const TextStyle(fontSize: 12, color: TossSurfaceTokens.textTertiary),
        ),
      ],
    );
  }
}

/// 5. 스켈레톤 & 빈 상태 뷰
class TossSkeletonList extends StatelessWidget {
  final int itemCount;
  const TossSkeletonList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TossSurfaceTokens.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 140,
                      decoration: BoxDecoration(
                        color: TossSurfaceTokens.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 200,
                      decoration: BoxDecoration(
                        color: TossSurfaceTokens.surface,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class TossEmptyStateView extends StatelessWidget {
  final String title;
  final String description;

  const TossEmptyStateView({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return TossSurfaceBox(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: TossSurfaceTokens.canvas,
              child: Icon(Icons.search, color: TossSurfaceTokens.textTertiary),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: TossSurfaceTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: TossSurfaceTokens.textTertiary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. 레이어링 규칙 시각화 카드 (canvas -> surface -> canvas 3단계 제한)
class TossLayeringRuleCard extends StatelessWidget {
  const TossLayeringRuleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return TossSurfaceBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TossSurfaceBox(
            color: TossSurfaceTokens.canvas,
            hasBorder: true,
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'canvas #FFFFFF — 리스트 · 본문',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'surface #F2F4F6 — 묶어야 할 블록. 이 위에 다시 흰 면을 얹어 한 단계를 만듭니다. 세 단계 이상 쌓지 않습니다.',
            style: TextStyle(fontSize: 12, color: TossSurfaceTokens.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
```

### ④ `lib/main.dart` (전체 컴포넌트 조립 및 실행)

```dart
import 'package:flutter/material.dart';
import 'theme/toss_surface_tokens.dart';
import 'models/category_model.dart';
import 'widgets/toss_surface_components.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SurfaceSystemDemoScreen(),
    ));

class SurfaceSystemDemoScreen extends StatefulWidget {
  const SurfaceSystemDemoScreen({super.key});

  @override
  State<SurfaceSystemDemoScreen> createState() => _SurfaceSystemDemoScreenState();
}

class _SurfaceSystemDemoScreenState extends State<SurfaceSystemDemoScreen> {
  // 카테고리 타일 데이터
  final List<CategoryItem> _categories = const [
    CategoryItem(label: '분식', icon: Icons.ramen_dining),
    CategoryItem(label: '간식', icon: Icons.bakery_dining),
    CategoryItem(label: '음료', icon: Icons.local_cafe),
    CategoryItem(label: '한식', icon: Icons.rice_bowl),
    CategoryItem(label: '굿즈', icon: Icons.shopping_bag),
    CategoryItem(label: '체험', icon: Icons.sports_esports),
    CategoryItem(label: '전시', icon: Icons.palette),
    CategoryItem(label: '특별부스', icon: Icons.school, isHighlighted: true),
  ];

  // 학생 아바타 데이터
  final List<StudentAvatarModel> _students = const [
    StudentAvatarModel(fullName: '이재원', isHighlighted: true),
    StudentAvatarModel(fullName: '박도현'),
    StudentAvatarModel(fullName: '김서연'),
    StudentAvatarModel(fullName: '한지우'),
  ];

  // 비동기 상태 시뮬레이션 (스켈레톤 <-> 카테고리 타일)
  late AsyncViewState<List<CategoryItem>> _categoryState;

  @override
  void initState() {
    super.initState();
    _categoryState = DataState(_categories);
  }

  void _toggleLoading() {
    setState(() {
      _categoryState = _categoryState is LoadingState
          ? DataState(_categories)
          : const LoadingState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossSurfaceTokens.canvas, // #FFFFFF 기본 캔버스
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('카테고리 타일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _toggleLoading,
                  child: Text(_categoryState is LoadingState ? '응답 완료 보기' : '스켈레톤 보기'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sealed Class 패턴 매칭을 통한 상태별 UI 다형성 렌더링
            switch (_categoryState) {
              LoadingState() => const TossSkeletonList(itemCount: 3),
              EmptyState(:final title, :final description) =>
                TossEmptyStateView(title: title, description: description),
              DataState(:final data) => Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: data.map((item) => TossCategoryTile(item: item)).toList(),
                ),
            },

            const SizedBox(height: 28),
            const Text('카드', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TossCreditCard(
              formattedBalance: '12,400',
              onChargeTap: () {},
              onQrPayTap: () {},
            ),
            const SizedBox(height: 10),
            const TossNoticeCard(
              title: '입금자명을 이렇게 보내주세요',
              subtitle: '학번과 이름이 다르면 자동 매칭에 실패해요',
            ),

            const SizedBox(height: 28),
            const Text('아바타', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _students.map((s) => TossTextAvatar(student: s)).toList(),
            ),

            const SizedBox(height: 28),
            const Text('빈 상태', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TossEmptyStateView(
              title: '검색 결과가 없어요',
              description: '반 번호(예: 2-3)나 메뉴 이름으로\n다시 검색해 보세요',
            ),

            const SizedBox(height: 28),
            const Text('레이어링 규칙', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TossLayeringRuleCard(),
          ],
        ),
      ),
    );
  }
}
```
