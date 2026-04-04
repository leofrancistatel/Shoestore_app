import 'package:flutter/material.dart';
import '../../services/auth_manager.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loggedIn = await AuthManager.isLoggedIn();
    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    name = await AuthManager.getName();
    email = await AuthManager.getEmail();
    setState(() {});
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Section
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(email ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Account Settings
                  const Text(
                    "Account Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        buildMenuItem(
                          Icons.person_outline,
                          "Personal Information",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.location_on_outlined,
                          "Saved Addresses",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.payment_outlined,
                          "Payment Methods",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.shopping_bag_outlined,
                          "Order History",
                          () {},
                        ),
                        buildMenuItem(Icons.favorite_border, "Wishlist", () {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Preferences
                  const Text(
                    "Preferences",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        buildMenuItem(
                          Icons.notifications_none,
                          "Notifications",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.lock_outline,
                          "Privacy & Security",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.settings_outlined,
                          "App Settings",
                          () {},
                        ),
                        buildMenuItem(
                          Icons.help_outline,
                          "Help & Support",
                          () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Sign Out",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        await AuthManager.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
