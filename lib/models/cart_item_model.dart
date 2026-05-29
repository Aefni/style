import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final String selectedSize;
  final String selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });
}
