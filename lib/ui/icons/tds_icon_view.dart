// lib/tds/tds_icon_view.dart
import 'package:flutter/material.dart';

import 'package:sdhs_bazaar_flutter/core/platform/platform_policy.dart';
import 'package:sdhs_bazaar_flutter/ui/icons/tds_icon.dart';

class TdsIconView extends StatelessWidget {
  const TdsIconView(this.icon, {super.key, this.size = 24, this.color});

  final TdsIcon icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      PlatformPolicy.of(context).resolveIcon(icon),
      size: size,
      color: color,
    );
  }
}
