import 'cart_item.dart';

class CartManager {
  // Singleton pattern
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> cartItems = [];

  /// Adds an item to the cart. If an item with the same name and size exists, increase its quantity.
  void addToCart(CartItem item) {
    final existingItem = cartItems.firstWhere(
      (cartItem) => cartItem.name == item.name && cartItem.size == item.size,
      orElse: () => CartItem(name: '', price: 0, size: 0, image: ''),
    );

    if (existingItem.name != '') {
      existingItem.quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
  }

  /// Removes an item from the cart completely
  void removeFromCart(CartItem item) {
    cartItems.removeWhere(
      (cartItem) => cartItem.name == item.name && cartItem.size == item.size,
    );
  }

  /// Decrease quantity of an item by 1, removes if quantity becomes 0
  void decrementItem(CartItem item) {
    final existingItem = cartItems.firstWhere(
      (cartItem) => cartItem.name == item.name && cartItem.size == item.size,
      orElse: () => CartItem(name: '', price: 0, size: 0, image: ''),
    );

    if (existingItem.name != '') {
      if (existingItem.quantity > 1) {
        existingItem.quantity--;
      } else {
        removeFromCart(existingItem);
      }
    }
  }

  /// Clears the entire cart
  void clearCart() {
    cartItems.clear();
  }

  /// Calculates subtotal
  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  /// Calculates tax at 10%
  double get tax => subtotal * 0.10;

  /// Total amount including tax
  double get total => subtotal + tax;
}
