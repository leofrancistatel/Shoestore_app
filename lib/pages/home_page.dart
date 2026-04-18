import 'package:flutter/material.dart';
import 'account_page.dart';
import 'cart_page.dart';
import 'product_details_page.dart';
import 'track_order_page.dart';
import 'login_page.dart';
import '../models/order_model.dart';
import '../database/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/':
              page = const HomeContent();
              break;
            case '/cart':
              page = const CartPage();
              break;
            case '/account':
              page = const AccountPage();
              break;
            case '/track':
              if (OrderModel.lastOrder != null) {
                page = TrackOrderPage(order: OrderModel.lastOrder!);
              } else {
                page = const NoOrderPage();
              }
              break;
            case '/login':
              page = const LoginPage();
              break;
            default:
              page = const HomeContent();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);

          switch (index) {
            case 0:
              _navigatorKey.currentState!.pushNamedAndRemoveUntil(
                '/',
                (r) => false,
              );
              break;
            case 1:
              _navigatorKey.currentState!.pushNamed('/track');
              break;
            case 2:
              _navigatorKey.currentState!.pushNamed('/cart');
              break;
            case 3:
              _navigatorKey.currentState!.pushNamed('/account');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            label: "Track Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

class NoOrderPage extends StatelessWidget {
  const NoOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "No orders found.",
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ),
    );
  }
}

/// ================= HOME CONTENT =================

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isLoggedIn = false;
  String firstName = "";

  final List<Map<String, dynamic>> products = const [
    {
      "title": "Air Max Runner",
      "category": "Running",
      "price": 129.99,
      "image": "assets/images/Shoes1.jpg",
    },
    {
      "title": "Classic Leather",
      "category": "Casual",
      "price": 89.99,
      "image": "assets/images/Shoes2.jpg",
    },
    {
      "title": "Sporty Sneakers",
      "category": "Sports",
      "price": 99.99,
      "image": "assets/images/Shoes3.jpg",
    },
    {
      "title": "Urban High Tops",
      "category": "Street",
      "price": 119.99,
      "image": "assets/images/Shoes4.jpg",
    },
    {
      "title": "White Casual Sneakers",
      "category": "Running",
      "price": 129.99,
      "image": "assets/images/Shoes5.jpg",
    },
    {
      "title": "Blue Trail Running Shoes",
      "category": "Casual",
      "price": 89.99,
      "image": "assets/images/Shoes6.jpg",
    },
    {
      "title": "Black Athletic Sneakers",
      "category": "Sports",
      "price": 99.99,
      "image": "assets/images/Shoes7.jpg",
    },
    {
      "title": "Black Formal Derby Shoes",
      "category": "Street",
      "price": 119.99,
      "image": "assets/images/Shoes8.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final logged = await AuthManager.isLoggedIn();
    String? name;

    if (logged) {
      name = await AuthManager.getName();
    }

    setState(() {
      isLoggedIn = logged;
      firstName = name ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "ShoeStore",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          isLoggedIn
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      "Hi, $firstName 👋",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed('/login');
                    loadUser();
                  },
                  child: const Text(
                    "Login / Sign Up",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HERO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step Into Style",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Discover our exclusive collection of premium footwear.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// PRODUCT LIST
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 20,
                children: products.map((product) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width > 800
                        ? (MediaQuery.of(context).size.width - 64) / 2
                        : MediaQuery.of(context).size.width - 32,
                    child: ProductCard(
                      title: product['title'],
                      category: product['category'],
                      price: product['price'],
                      image: product['image'],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            /// FEATURE SECTION
            const FeatureSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// ================= PRODUCT CARD =================

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final double price;
  final String image;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(category, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(
                            title: title,
                            category: category,
                            price: price,
                            image: image,
                          ),
                        ),
                      );
                    },
                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= FEATURE SECTION =================

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          FeatureItem(
            icon: Icons.check,
            title: "Premium Quality",
            description: "All our shoes are made with the finest materials",
          ),
          SizedBox(height: 40),
          FeatureItem(
            icon: Icons.attach_money,
            title: "Best Prices",
            description: "Competitive pricing on all products",
          ),
          SizedBox(height: 40),
          FeatureItem(
            icon: Icons.local_shipping,
            title: "Fast Delivery",
            description: "Get your shoes delivered within 3-5 days",
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF0F172A),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
