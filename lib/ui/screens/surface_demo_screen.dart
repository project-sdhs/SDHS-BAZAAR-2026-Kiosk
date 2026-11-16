import 'package:sdhs_bazaar_flutter/state/async_view_state.dart';
import 'package:flutter/material.dart';
import 'package:sdhs_bazaar_flutter/core/theme/toss_surface_tokens.dart';
import 'package:sdhs_bazaar_flutter/ui/models/category_model.dart';
import 'package:sdhs_bazaar_flutter/ui/widgets/surface/toss_surface_components.dart';

class SurfaceSystemDemoScreen extends StatefulWidget {
  const SurfaceSystemDemoScreen({super.key});

  @override
  State<SurfaceSystemDemoScreen> createState() =>
      _SurfaceSystemDemoScreenState();
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
                const Text('카테고리 타일',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _toggleLoading,
                  child: Text(
                      _categoryState is LoadingState ? '응답 완료 보기' : '스켈레톤 보기'),
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
                  children:
                      data.map((item) => TossCategoryTile(item: item)).toList(),
                ),
            },

            const SizedBox(height: 28),
            const Text('카드',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text('아바타',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  _students.map((s) => TossTextAvatar(student: s)).toList(),
            ),

            const SizedBox(height: 28),
            const Text('빈 상태',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TossEmptyStateView(
              title: '검색 결과가 없어요',
              description: '반 번호(예: 2-3)나 메뉴 이름으로\n다시 검색해 보세요',
            ),

            const SizedBox(height: 28),
            const Text('레이어링 규칙',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TossLayeringRuleCard(),
          ],
        ),
      ),
    );
  }
}
