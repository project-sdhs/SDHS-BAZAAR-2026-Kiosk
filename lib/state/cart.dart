import 'package:flutter/foundation.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';

class Cart extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => List.unmodifiable(_items.values);
  int get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);
  void add(Product product) {
    final current = _items[product.id];
    _items[product.id] =
        CartItem(product: product, quantity: (current?.quantity ?? 0) + 1);
    notifyListeners();
  }

  void remove(String productId) {
    if (_items.remove(productId) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
