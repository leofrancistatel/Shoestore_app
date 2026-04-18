import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_manager.dart';
import '../../database/app_database.dart';
import 'dart:math';

import 'cart_manager.dart';
import 'cart_item.dart';
import '../../models/order_model.dart';
import 'track_order_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  String paymentMethod = "Credit/Debit Card";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await AuthManager.getName();
    final email = await AuthManager.getEmail();

    if (!mounted) return;

    setState(() {
      nameController.text = name ?? "";
      emailController.text = email ?? "";
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Shipping Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField("Name", nameController),
                    const SizedBox(height: 12),
                    _buildTextField("Email", emailController),
                    const SizedBox(height: 12),
                    _buildTextField("Address", addressController),
                    const SizedBox(height: 12),
                    _buildTextField("City", cityController),
                    const SizedBox(height: 12),
                    _buildTextField("Zip Code", zipController),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _paymentOption("Credit/Debit Card"),
              _paymentOption("PayPal"),
              _paymentOption("Bank Transfer"),
              const SizedBox(height: 20),
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ...cart.cartItems.map((item) => _orderItem(item)),
                      const Divider(),
                      _buildRow("Subtotal", cart.subtotal),
                      _buildRow("Tax", cart.tax),
                      _buildRow("Shipping", 0),
                      const Divider(),
                      _buildRow("Total", cart.total, isBold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    try {
                      final order = OrderModel(
                        orderId: _generateOrderId(),
                        trackingNumber: _generateTrackingNumber(),
                        orderDate: DateTime.now(),
                        estimatedDelivery: DateTime.now().add(
                          const Duration(days: 4),
                        ),
                        name: nameController.text.trim(),
                        address: addressController.text.trim(),
                        city: cityController.text.trim(),
                        zip: zipController.text.trim(),
                        items: List.from(cart.cartItems),
                      );

                      await AppDatabase.instance.insertOrder(
                        {
                          'order_id': order.orderId,
                          'tracking_number': order.trackingNumber,
                          'order_date': order.orderDate.toIso8601String(),
                          'estimated_delivery':
                              order.estimatedDelivery.toIso8601String(),
                          'name': order.name,
                          'address': order.address,
                          'city': order.city,
                          'zip': order.zip,
                          'total': cart.total,
                          'payment_method': paymentMethod,
                        },
                        order.items.map((item) {
                          return {
                            'order_id': order.orderId,
                            'product_name': item.name,
                            'price': item.price,
                            'size': item.size,
                            'quantity': item.quantity,
                            'image': item.image,
                          };
                        }).toList(),
                      );

                      OrderModel.lastOrder = order;
                      cart.clearCart();

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackOrderPage(order: order),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order failed: $e")),
                      );
                    }
                  },
                  child: const Text("Place Order"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "Please enter $label";
        return null;
      },
    );
  }

  Widget _paymentOption(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        title: Text(title),
        value: title,
        groupValue: paymentMethod,
        onChanged: (val) {
          setState(() {
            paymentMethod = val!;
          });
        },
      ),
    );
  }

  Widget _orderItem(CartItem item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text("Size: ${item.size} × ${item.quantity}"),
      trailing: Text("\$${(item.price * item.quantity).toStringAsFixed(2)}"),
    );
  }

  Widget _buildRow(String title, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value == 0 ? "FREE" : "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return List.generate(10, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  String _generateTrackingNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return "TRK" +
        List.generate(12, (_) => chars[rnd.nextInt(chars.length)]).join();
  }
}
