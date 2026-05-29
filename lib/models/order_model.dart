import 'cart_item_model.dart';

class Order {
  final String orderId;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String status;
  final String deliveryAddress;

  Order({
    required this.orderId,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    required this.deliveryAddress,
  });
}
