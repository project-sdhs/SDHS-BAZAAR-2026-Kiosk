# SDHS-BAZAAR-2026-Kiosk

서울디지텍고등학교 2026 디지텍 바자회 · 부스 메뉴판(키오스크) (Flutter, 웹 + Android + iOS).
부스 태블릿에 띄워 두고 그 부스의 메뉴와 결제 QR을 보여 줍니다. 키오스크에서는 주문을 받지 않습니다.

## 준비

- Flutter **3.47.1** (stable) / Dart 3.13.1 — `flutter --version` 으로 확인
- 패키지 설치: `flutter pub get`

## 실행

```bash
flutter run -d chrome          # 웹 (가장 간단)
flutter run                    # 연결된 태블릿 / 시뮬레이터
```

서버 주소는 기본 `http://localhost:3000` 입니다. 바꾸려면:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://192.168.0.10:3000
```

> 웹에서 다른 주소의 서버를 부르려면 서버 쪽 CORS 허용이 필요합니다.

## 검사 · 테스트 (PR 올리기 전에 모두 통과해야 합니다)

```bash
dart format .        # 코드 모양 맞추기 (CI 는 바뀌는 게 있으면 실패)
flutter analyze      # 정적 분석
flutter test         # 위젯 · 단위 테스트
flutter build web    # 웹 빌드가 깨지지 않는지 확인
```

## 빌드

```bash
flutter build web --dart-define=API_BASE_URL=<서버 주소>   # 결과물: build/web/
flutter build apk --dart-define=API_BASE_URL=<서버 주소>   # Android (Android SDK 필요)
flutter build ipa --dart-define=API_BASE_URL=<서버 주소>   # iOS (Mac + Xcode 필요)
```

## 폴더 구조

```
lib/
  main.dart            앱 시작점 (runApp 만)
  app.dart             MaterialApp.router + 테마 + Provider 연결
  core/
    theme/             디자인 토큰: 컬러 · 타입 · 간격/라디우스 · ThemeData
    router/            go_router 설정 (app_router.dart), 경로 상수 (routes.dart)
    constants/         앱 전체 고정 값
    utils/             작은 도우미 함수
  data/
    api/               ApiClient (http, 서버 주소 · JSON · 에러 처리)
    models/            서버 데이터 클래스 (fromJson / toJson)
    repositories/      ApiClient → model 로 바꿔 주는 저장소
  state/               provider 의 ChangeNotifier 상태
  ui/
    components/        여러 화면에서 쓰는 위젯
    pages/             화면 1개 = 폴더 1개 (menu_board/ …)
test/                  lib/ 와 같은 구조로 테스트를 둡니다
web/ android/ ios/     플랫폼별 설정 (flutter create 가 만든 파일)
```

화면 색 · 글자 · 여백은 `core/theme` 의 토큰(`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`)만 씁니다.
`Color(0xFF...)` 를 화면 코드에 직접 쓰지 마세요. 폰트는 기기 기본 폰트를 씁니다(Pretendard 미포함).

## 브랜치 · PR 규칙

1. 항상 최신 `main` 에서 브랜치를 만듭니다. `main` 에 직접 push 하지 않습니다.
2. 브랜치 이름: `feat/…` (기능), `fix/…` (버그), `chore/…` (설정 · 정리) — 예: `feat/menu-board-list`
3. 커밋 메시지: [Conventional Commits](https://www.conventionalcommits.org/ko/) — 예: `feat: 메뉴판 목록 표시`
4. PR 템플릿(무엇을 · 왜 · 확인한 것 · 스크린샷)을 채워서 올립니다.
5. CI 통과 + 리뷰 승인 → **Squash merge**.
