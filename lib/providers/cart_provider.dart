import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void addItem(Product product, String size, String color) {
    _items.add(CartItem(product: product, selectedSize: size, selectedColor: color));
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    item.quantity = quantity;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
