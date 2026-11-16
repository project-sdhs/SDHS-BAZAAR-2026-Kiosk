import 'package:flutter/widgets.dart';

/// 눌리는 것(키패드 숫자 버튼 등)의 기반 위젯.
///
/// - 누르는 동안 투명도를 낮춥니다. 테마 원칙대로 물결(ripple) 효과는 쓰지 않아요.
/// - 터치 영역은 최소 [minTouchTarget] × [minTouchTarget] 을 보장합니다.
/// - [onTap] 이 null 이면 비활성 상태라 눌러도 반응하지 않아요.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.pressedOpacity = 0.4,
  });

  /// 터치 영역 최소 크기
  static const double minTouchTarget = 48;

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// 누르고 있는 동안의 투명도 (1 = 그대로)
  final double pressedOpacity;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        child: AnimatedOpacity(
          opacity: _pressed ? widget.pressedOpacity : 1,
          duration: const Duration(milliseconds: 100),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: Pressable.minTouchTarget,
              minHeight: Pressable.minTouchTarget,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
