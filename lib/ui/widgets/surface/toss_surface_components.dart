import 'package:flutter/material.dart';
import 'package:sdhs_bazaar_flutter/core/theme/toss_surface_tokens.dart';
import 'package:sdhs_bazaar_flutter/ui/models/category_model.dart';

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
            style:
                TextStyle(fontSize: 13, color: TossSurfaceTokens.textSecondary),
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
                child: Text('C',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
                  label: const Text('충전하기',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossSurfaceTokens.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onQrPayTap,
                  icon: const Icon(Icons.qr_code_2, size: 18),
                  label: const Text('QR 결제',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossSurfaceTokens.canvas,
                    foregroundColor: TossSurfaceTokens.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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

  const TossNoticeCard(
      {super.key, required this.title, required this.subtitle});

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
            style: const TextStyle(
                fontSize: 12, color: TossSurfaceTokens.textSecondary),
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
          style: const TextStyle(
              fontSize: 12, color: TossSurfaceTokens.textTertiary),
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
            style: TextStyle(
                fontSize: 12,
                color: TossSurfaceTokens.textSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
