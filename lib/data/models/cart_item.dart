import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  const CartItem({required this.product, required this.quantity});
  int get subtotal => product.price * quantity;
}
