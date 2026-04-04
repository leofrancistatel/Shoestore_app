import '../pages/cart_item.dart';

class OrderModel {
  final String orderId;
  final String trackingNumber;
  final DateTime orderDate;
  final DateTime estimatedDelivery;
  final String name;
  final String address;
  final String city;
  final String zip;
  final List<CartItem> items;

  OrderModel({
    required this.orderId,
    required this.trackingNumber,
    required this.orderDate,
    required this.estimatedDelivery,
    required this.name,
    required this.address,
    required this.city,
    required this.zip,
    required this.items,
  });

  static OrderModel? lastOrder; // ✅ ADD THIS

  double get subtotal =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get tax => subtotal * 0.10;

  double get total => subtotal + tax;
}
