// lib/tds/press_feedback.dart
//
// "누름 반응: 플랫폼 기본" 을 전략(Strategy) 객체로 분리.
// iOS는 투명도, Android는 리플. 새 방식이 필요하면 클래스만 하나 추가하면 된다.
import 'package:flutter/material.dart';

abstract class PressFeedback {
  const PressFeedback();

  Widget wrap({
    required Widget child,
    required VoidCallback? onTap,
    BorderRadius? radius,
    Color? color,
  });
}

/// Android: 리플
class RippleFeedback extends PressFeedback {
  const RippleFeedback();

  @override
  Widget wrap({
    required Widget child,
    required VoidCallback? onTap,
    BorderRadius? radius,
    Color? color,
  }) {
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}

/// iOS: 누르는 동안 투명도 감소
class OpacityFeedback extends PressFeedback {
  const OpacityFeedback({this.pressedOpacity = 0.4});

  final double pressedOpacity;

  @override
  Widget wrap({
    required Widget child,
    required VoidCallback? onTap,
    BorderRadius? radius,
    Color? color,
  }) {
    return _OpacityPressable(
      onTap: onTap,
      pressedOpacity: pressedOpacity,
      radius: radius,
      color: color,
      child: child,
    );
  }
}

class _OpacityPressable extends StatefulWidget {
  const _OpacityPressable({
    required this.child,
    required this.onTap,
    required this.pressedOpacity,
    this.radius,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedOpacity;
  final BorderRadius? radius;
  final Color? color;

  @override
  State<_OpacityPressable> createState() => _OpacityPressableState();
}

class _OpacityPressableState extends State<_OpacityPressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: enabled ? (_) => _set(true) : null,
      onTapUp: enabled ? (_) => _set(false) : null,
      onTapCancel: enabled ? () => _set(false) : null,
      child: AnimatedOpacity(
        opacity: _pressed ? widget.pressedOpacity : 1,
        duration: const Duration(milliseconds: 100),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.radius,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
