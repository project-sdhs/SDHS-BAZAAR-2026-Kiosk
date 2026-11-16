import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../state/cart.dart';
import '../widgets/product_card.dart';

class BazaarScreen extends StatefulWidget {
  const BazaarScreen({super.key});
  @override
  State<BazaarScreen> createState() => _BazaarScreenState();
}

class _BazaarScreenState extends State<BazaarScreen> {
  final Cart _cart = Cart();
  late final List<Product> _products;
  @override
  void initState() {
    super.initState();
    _products = InMemoryProductRepository.demo().getProducts();
  }

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('디지텍 바자회')),
        body: SafeArea(
            child: ListenableBuilder(
          listenable: _cart,
          builder: (context, child) =>
              ListView(padding: const EdgeInsets.all(16), children: [
            for (final product in _products)
              ProductCard(product: product, onAdd: () => _cart.add(product)),
            const SizedBox(height: 24),
            Text('장바구니', style: Theme.of(context).textTheme.titleLarge),
            if (_cart.items.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16), child: Text('담은 상품이 없습니다.')),
            for (final item in _cart.items)
              ListTile(
                title: Text('${item.product.name} × ${item.quantity}개'),
                subtitle: Text('${item.subtotal}원'),
                trailing: IconButton(
                    tooltip: '상품 삭제',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _cart.remove(item.product.id)),
              ),
            Text('총금액: ${_cart.totalPrice}원'),
          ]),
        )),
      );
}
