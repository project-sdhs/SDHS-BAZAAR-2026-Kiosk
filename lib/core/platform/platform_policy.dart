// lib/tds/platform_policy.dart
//
// 플랫폼마다 달라지는 동작은 전부 여기로 모은다.
// 컴포넌트는 `PlatformPolicy.of(context)`만 보고 Platform.isIOS 같은 분기를 쓰지 않는다.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/core/platform/press_feedback.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';

abstract class PlatformPolicy {
  const PlatformPolicy();

  /// 누름 반응 (iOS 투명도 / Android 리플)
  PressFeedback get pressFeedback;

  /// 아이콘 매핑 (iOS CupertinoIcons / Android Icons)
  IconData resolveIcon(TdsIcon icon);

  /// 뒤로가기: 엣지 스와이프 + 시스템 백 둘 다 지원하는 라우트
  PageRoute<T> buildRoute<T>(WidgetBuilder builder, {RouteSettings? settings});

  /// Theme의 platform을 따르므로 테스트나 미리보기에서 바꿔 끼우기 쉽다.
  static PlatformPolicy of(BuildContext context) =>
      forPlatform(Theme.of(context).platform);

  static PlatformPolicy forPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const IosPolicy();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const AndroidPolicy();
    }
  }
}

class IosPolicy extends PlatformPolicy {
  const IosPolicy();

  @override
  PressFeedback get pressFeedback => const OpacityFeedback();

  @override
  IconData resolveIcon(TdsIcon icon) => icon.cupertino;

  @override
  PageRoute<T> buildRoute<T>(WidgetBuilder builder, {RouteSettings? settings}) {
    return CupertinoPageRoute<T>(builder: builder, settings: settings);
  }
}

class AndroidPolicy extends PlatformPolicy {
  const AndroidPolicy();

  @override
  PressFeedback get pressFeedback => const RippleFeedback();

  @override
  IconData resolveIcon(TdsIcon icon) => icon.material;

  @override
  PageRoute<T> buildRoute<T>(WidgetBuilder builder, {RouteSettings? settings}) {
    return MaterialPageRoute<T>(builder: builder, settings: settings);
  }
}
