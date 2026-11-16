# 디지텍 바자회 Flutter 객체지향 정리본

사용자가 제공한 Markdown 2개와 tds_flutter.zip, 앞서 채팅으로 제안한 Dart 예시를 하나의 Flutter 프로젝트로 정리했습니다.
폴더 구조는 https://github.com/project-sdhs/SDHS-BAZAAR-2026-Kiosk 의 lib 구조를 참고했습니다.
원격 저장소에 업로드하거나 기존 저장소 파일을 변경하지 않았습니다.

## 실행

Flutter SDK가 설치된 환경에서 이 폴더를 열고 실행합니다.

```sh
flutter pub get
flutter run -d chrome
```

웹 실행용 web/ 폴더를 포함합니다. Android/iOS 프로젝트 파일이 필요하면 별도 복사본에서 flutter create --platforms=android,ios . 명령으로 생성하세요.
기존 학교 프로젝트에 합칠 때는 lib 전체를 덮어쓰지 말고 docs/FILE_MAP.md를 보면서 필요한 파일을 옮긴 뒤 기존 app.dart와 main.dart에 연결하세요.

## 폴더 역할

- core/theme: 색상, 글꼴 이름, 규격 및 테마.
- core/platform: iOS/Android 아이콘·누름 반응·화면 전환 전략.
- data/api: 향후 서버 통신 코드 위치 안내.
- data/models: 상품, 장바구니 항목, 판매자.
- data/repositories: 상품 제공 인터페이스와 메모리 구현.
- state: 장바구니 변경 알림과 비동기 화면 상태.
- ui/models: 아이콘·콜백이 있는 화면 전용 데이터.
- ui/widgets: 제공된 컴포넌트와 이전 채팅의 버튼·상품 카드.
- ui/screens: 상품 데모와 제공 자료의 데모 화면 세 개.
- docs: 출처, 파일 대응표, 원본 Markdown.

## 객체지향 적용

Product/Seller는 데이터와 상품 등록을, Cart는 담기·삭제·합계와 변경 알림을 담당합니다.
ProductRepository 추상 클래스와 InMemoryProductRepository 구현체를 통해 UI에서 데이터 공급을 분리했습니다.
PlatformPolicy와 PressFeedback은 플랫폼별 동작을 전략 객체로 분리합니다.
TossSurfaceBox 등 공통 위젯을 다른 위젯에 합성해 사용합니다.

## 디자인 및 동작 범위

- 파운데이션의 primary #0171CE, danger #E42939 및 중립색을 반영했습니다.
- 원본 ZIP의 TdsButton은 56/r16 규격을 유지하며, 이전 채팅의 BazaarButton은 32/38/48/56 크기를 지원합니다.
- 실제 Pretendard 폰트 파일은 제공되지 않아 포함하지 않았습니다. 현재 시스템 대체 글꼴로 표시됩니다. 폰트 파일을 추가하고 pubspec.yaml의 flutter/fonts에 등록하면 적용됩니다.
- 원본 문서의 충전·결제·QR·지도·검색 예시는 UI 시연이며 실제 기능이 아닙니다. 표시되는 성공 문구도 서버 처리 결과가 아닙니다.
- 새 상품 화면의 담기·삭제·합계는 동작하지만 메모리 상태이므로 화면을 닫으면 초기화됩니다.
- 입력창 변형 전체, 역할 배지 등 이미지에만 있는 요소는 원본 코드 범위 밖이며 이 정리본에서 추가 구현하지 않았습니다.

## 검증

flutter analyze
flutter test
flutter build web

실행 결과는 docs/VALIDATION.md를 확인하세요.
