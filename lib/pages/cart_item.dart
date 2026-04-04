class CartItem {
  final String name;
  final double price;
  final int size;
  final String
  image; // should be a local asset path like "assets/images/Shoes1.jpg"
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.size,
    required this.image,
    this.quantity = 1, // default quantity is 1
  });

  // Optional: helper to increase quantity
  void increment() => quantity++;

  // Optional: helper to decrease quantity
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
