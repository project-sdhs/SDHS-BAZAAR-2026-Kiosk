import 'package:flutter_test/flutter_test.dart';
import 'package:sdhs_bazaar_flutter/data/models/product.dart';
import 'package:sdhs_bazaar_flutter/state/cart.dart';

void main() {
  test('같은 상품을 담으면 수량과 합계가 증가하고 삭제하면 제거된다', () {
    final cart = Cart();
    addTearDown(cart.dispose);
    var changes = 0;
    cart.addListener(() => changes++);
    final product = Product(id: 'p', name: '도서', price: 3000, sellerId: 's');
    cart.add(product);
    cart.add(product);
    expect(cart.items.single.quantity, 2);
    expect(cart.totalPrice, 6000);
    expect(() => cart.items.clear(), throwsUnsupportedError);
    cart.remove('p');
    expect(cart.items, isEmpty);
    expect(cart.totalPrice, 0);
    expect(changes, 3);
  });
  test('음수 가격은 허용하지 않는다', () {
    expect(() => Product(id: 'p', name: '도서', price: -1, sellerId: 's'),
        throwsArgumentError);
  });
}
