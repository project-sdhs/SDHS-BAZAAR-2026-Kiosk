import 'product.dart';

class Seller {
  final String id;
  final String name;
  final List<Product> _products = [];
  Seller({required this.id, required this.name});
  List<Product> get products => List.unmodifiable(_products);
  Product registerProduct(
      {required String productId, required String name, required int price}) {
    if (_products.any((p) => p.id == productId))
      throw StateError('이미 등록된 상품 ID입니다.');
    final product =
        Product(id: productId, name: name, price: price, sellerId: id);
    _products.add(product);
    return product;
  }
}
