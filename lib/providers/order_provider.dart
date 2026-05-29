import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void placeOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }
}
