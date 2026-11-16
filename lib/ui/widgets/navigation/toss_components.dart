import 'package:sdhs_bazaar_flutter/core/theme/tds_tokens.dart';
import 'package:flutter/material.dart';
import 'package:sdhs_bazaar_flutter/ui/models/list_item_model.dart';

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
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
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
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
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
          color: _isFocused ? TdsColors.primary : Colors.transparent,
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
                  icon:
                      Icon(Icons.cancel, color: Colors.grey.shade400, size: 20),
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
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color:
                            isSelected ? Colors.black87 : Colors.grey.shade600,
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
          title: Text(booth.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(booth.subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(booth.priceText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text(booth.orderCountText,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
      NavigationRowItem nav => ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: nav.onTap,
          leading: _buildIconBox(nav.icon),
          title: Text(nav.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(nav.subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ToggleRowItem toggle => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: toggle.isEnabled,
          onChanged: toggle.onChanged,
          activeThumbColor: TdsColors.primary,
          title: Text(toggle.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                backgroundColor: const Color(0xFFEDF5FC),
                foregroundColor: TdsColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(secondaryText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
                backgroundColor: TdsColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(primaryText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
