import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/theme/app_theme.dart';
import 'data/api/api_client.dart';

/// 키오스크 앱의 뿌리 위젯: 테마, 라우터, 공용 객체(Provider)를 연결합니다.
class BazaarKioskApp extends StatefulWidget {
  const BazaarKioskApp({super.key, this.initialLocation = Routes.menuBoard});

  /// 처음 보여줄 경로. 테스트에서 특정 화면부터 시작할 때만 바꿉니다.
  final String initialLocation;

  @override
  State<BazaarKioskApp> createState() => _BazaarKioskAppState();
}

class _BazaarKioskAppState extends State<BazaarKioskApp> {
  late final GoRouter _router = createAppRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 어디서든 `context.read<ApiClient>()` 로 꺼내 쓸 수 있어요.
    // 상태 저장소(state/)를 만들면 MultiProvider 로 바꿔 여기에 함께 등록합니다.
    return Provider<ApiClient>(
      create: (_) => ApiClient(),
      dispose: (_, client) => client.close(),
      child: MaterialApp.router(
        title: '디지텍 바자회 키오스크',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
