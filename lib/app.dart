import 'package:flutter/material.dart';
import 'core/theme/tds_theme.dart';
import 'ui/screens/demo_home_screen.dart';

class BazaarApp extends StatelessWidget {
  const BazaarApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '디지텍 바자회',
        debugShowCheckedModeBanner: false,
        theme: TdsTheme.light(),
        home: const DemoHomeScreen(),
      );
}
