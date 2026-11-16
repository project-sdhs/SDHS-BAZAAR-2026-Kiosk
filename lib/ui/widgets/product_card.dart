import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import 'bazaar_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  const ProductCard({super.key, required this.product, required this.onAdd});
  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(product.name),
        subtitle: Text('${product.price}원'),
        trailing: BazaarButton(label: '담기', onPressed: onAdd),
      );
}
