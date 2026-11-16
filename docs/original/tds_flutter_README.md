# TDS 멀티플랫폼 대응 (Flutter)

## 파일 배치

```
lib/
├─ main.dart                 # 사용 예제
└─ tds/
   ├─ tds.dart               # barrel (외부에서는 이것만 import)
   ├─ tds_tokens.dart        # 수치·색·타이포 토큰 (표의 "우리 결정")
   ├─ tds_icon.dart          # 아이콘 이름 한 벌 → Icons / CupertinoIcons 매핑
   ├─ tds_icon_view.dart
   ├─ press_feedback.dart    # 누름 반응 전략: Ripple / Opacity
   ├─ platform_policy.dart   # 플랫폼 분기는 전부 여기
   ├─ tds_pressable.dart     # 터치 타겟 48 + 누름 반응
   ├─ tds_button.dart        # 56 · r16 · 17/600
   ├─ tds_dialog.dart        # TDS Dialog 한 벌
   ├─ tds_bottom_sheet.dart  # 바텀시트 한 벌
   ├─ tds_bottom_nav.dart    # 4탭 + 가운데 QR
   ├─ tds_scaffold.dart      # 뒤로가기만 있는 상단 바 + SafeArea
   └─ tds_theme.dart
```

## 설계 원칙

- 컴포넌트에서 `Platform.isIOS` 같은 분기를 쓰지 않는다. 갈라지는 건 `PlatformPolicy`(IosPolicy / AndroidPolicy)만 안다.
- 표의 "우리 결정"이 한 벌인 항목(폰트, 버튼, 경고창, 선택 메뉴, 깊이)은 `tds_tokens.dart`나 컴포넌트 하나로 통일했다.
- 표에서 플랫폼 기본을 따르는 항목(누름 반응, 뒤로가기 라우트, 아이콘)은 `PlatformPolicy`가 담당한다.
- 새 플랫폼 동작이 필요하면 `PlatformPolicy`에 메서드를 추가하고 두 구현체만 채우면 된다.

## 표 항목과 코드 대응

| 항목 | 위치 |
|---|---|
| 기준 폰트 Pretendard | `TdsTypography.fontFamily` |
| 본문 16/24 | `TdsMetrics.bodyFontSize`, `bodyLineHeight` |
| 주 버튼 56 · r16 · 17/600 | `TdsButton`, `TdsMetrics.button*` |
| 터치 타겟 48 | `TdsPressable` |
| 상단 바 (뒤로가기만) | `TdsScaffold` |
| 뒤로가기 둘 다 지원 | `PlatformPolicy.buildRoute` |
| 하단 탭 4개 + QR | `TdsBottomNav` |
| 누름 반응 | `PressFeedback` |
| 경고창 | `TdsDialog` |
| 선택 메뉴 | `TdsBottomSheet` |
| 깊이 (평면) | elevation 0 + 얇은 divider |
| 가장자리 | `SafeArea` |

## pubspec.yaml

```yaml
flutter:
  fonts:
    - family: Pretendard
      fonts:
        - asset: assets/fonts/Pretendard-Regular.otf
        - asset: assets/fonts/Pretendard-Medium.otf
          weight: 500
        - asset: assets/fonts/Pretendard-SemiBold.otf
          weight: 600
        - asset: assets/fonts/Pretendard-Bold.otf
          weight: 700

dependencies:
  cupertino_icons: ^1.0.8
```

## 참고

- 색상값은 표에 없어서 임시값입니다. 디자인 시스템 값으로 바꿔 주세요.
- `CupertinoIcons` 이름은 설치된 `cupertino_icons` 버전에 따라 없는 것이 있을 수 있어서, 컴파일 에러가 나면 `tds_icon.dart`의 해당 줄만 바꾸면 됩니다.
