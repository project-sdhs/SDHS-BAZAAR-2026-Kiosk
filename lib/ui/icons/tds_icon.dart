// lib/tds/tds_icon.dart
//
// 아이콘 이름은 한 벌, 실제 글리프는 플랫폼별로 매핑한다.
// 화면 코드에서는 Icons.* / CupertinoIcons.*를 직접 쓰지 않고 TdsIcon만 쓴다.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TdsIcon {
  home(Icons.home_rounded, CupertinoIcons.house),
  storefront(Icons.storefront_rounded, CupertinoIcons.bag),
  map(Icons.map_rounded, CupertinoIcons.map),
  person(Icons.person_rounded, CupertinoIcons.person),
  search(Icons.search_rounded, CupertinoIcons.search),
  tune(Icons.tune_rounded, CupertinoIcons.slider_horizontal_3),
  chevronRight(Icons.chevron_right_rounded, CupertinoIcons.chevron_right),
  arrowBackIosNew(Icons.arrow_back_ios_new_rounded, CupertinoIcons.back),
  notifications(Icons.notifications_rounded, CupertinoIcons.bell),
  locationOn(Icons.location_on_rounded, CupertinoIcons.location_solid),
  qrCode2(Icons.qr_code_2_rounded, CupertinoIcons.qrcode),
  receiptLong(Icons.receipt_long_rounded, CupertinoIcons.doc_text),
  accountBalance(Icons.account_balance_rounded, CupertinoIcons.building_2_fill),
  shield(Icons.shield_rounded, CupertinoIcons.shield),
  myLocation(Icons.my_location_rounded, CupertinoIcons.scope),
  close(Icons.close_rounded, CupertinoIcons.xmark),
  qrCodeScanner(
      Icons.qr_code_scanner_rounded, CupertinoIcons.qrcode_viewfinder),
  // 현재 Flutter에 없는 손전등 글리프 대신 플랫폼 기본 번개 아이콘을 사용합니다.
  flashlightOn(Icons.flashlight_on_rounded, CupertinoIcons.bolt_fill);

  const TdsIcon(this.material, this.cupertino);

  final IconData material; // Android
  final IconData cupertino; // iOS
}
