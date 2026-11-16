import '../models/product.dart';
import '../models/seller.dart';

abstract class ProductRepository {
  List<Product> getProducts();
}

/// 서버 연결 전 사용하는 메모리 저장소. 실제 API 호출은 하지 않습니다.
class InMemoryProductRepository implements ProductRepository {
  final Seller _seller;
  InMemoryProductRepository(this._seller);
  factory InMemoryProductRepository.demo() {
    final seller = Seller(id: 'seller-1', name: '디지텍 학생회');
    seller.registerProduct(productId: 'product-1', name: '중고 도서', price: 3000);
    seller.registerProduct(productId: 'product-2', name: '키링', price: 2000);
    return InMemoryProductRepository(seller);
  }
  @override
  List<Product> getProducts() => _seller.products;
}
