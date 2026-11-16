class Product {
  final String id;
  final String name;
  final int price;
  final String sellerId;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.sellerId}) {
    if (price < 0)
      throw ArgumentError.value(price, 'price', '가격은 0원 이상이어야 합니다.');
  }
}
