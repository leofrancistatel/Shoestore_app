import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class TrackOrderPage extends StatelessWidget {
  final OrderModel order;

  const TrackOrderPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final int daysLeft = order.estimatedDelivery
        .difference(DateTime.now())
        .inDays; // Calculate remaining days

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Track Your Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= HEADER CARD =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your order is on the way!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    daysLeft > 0
                        ? "Delivery in $daysLeft days"
                        : "Delivery today!",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= ORDER SUMMARY =================
            _card(
              title: "Order Summary",
              child: Column(
                children: [
                  _row("Order ID", "#${order.orderId}"),
                  _row("Tracking No", order.trackingNumber),
                  _row("Order Date", _formatDate(order.orderDate)),
                  _row(
                    "Delivery",
                    daysLeft > 0 ? "In $daysLeft days" : "Arrived",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= SHIPPING ADDRESS =================
            _card(
              title: "Shipping Address",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(order.address),
                  Text("${order.city}, ${order.zip}"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= ORDER ITEMS =================
            _card(
              title: "Order Items",
              child: Column(
                children: [
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Size: ${item.size}"),
                              Text("Qty: ${item.quantity}"),
                            ],
                          ),
                          Text(
                            "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= PAYMENT SUMMARY =================
            _card(
              title: "Payment Details",
              child: Column(
                children: [
                  _row("Subtotal", "\$${order.subtotal.toStringAsFixed(2)}"),
                  _row("Tax", "\$${order.tax.toStringAsFixed(2)}"),
                  _row("Shipping", "FREE"),
                  const Divider(),
                  _row(
                    "Total",
                    "\$${order.total.toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MODERN CARD =================
  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
