import 'package:flutter/material.dart';

/// 카테고리 타일 도메인 모델
class CategoryItem {
  final String label;
  final IconData icon;
  final bool isHighlighted; // 특별부스 등 weak 틴트 적용 여부

  const CategoryItem({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
  });
}

/// 아바타 도메인 모델 (프로필 사진 없이 성(첫 글자)만 추출하는 로직 캡슐화)
class StudentAvatarModel {
  final String fullName;
  final bool isHighlighted;

  const StudentAvatarModel({
    required this.fullName,
    this.isHighlighted = false,
  });

  /// 이름에서 첫 글자(성)를 안전하게 추출하는 Getter
  String get initial => fullName.isNotEmpty ? fullName.characters.first : '?';
}

/// [추상화 & 다형성] 비동기 데이터 로딩 상태 계층 (스켈레톤 -> 데이터 or 빈 상태)
