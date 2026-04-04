import 'package:flutter/material.dart';
import '../../services/auth_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    if (isLogin) {
      /// LOGIN
      final storedEmail = await AuthManager.getEmail();
      final storedPassword = await AuthManager.getPassword();

      if (email == storedEmail && password == storedPassword) {
        await AuthManager.saveLogin(
          email: email,
          name: await AuthManager.getName() ?? "User",
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    } else {
      /// SIGN UP
      await AuthManager.registerUser(
        name: name,
        email: email,
        password: password,
      );

      await AuthManager.saveLogin(email: email, name: name);

      Navigator.pushReplacementNamed(context, '/');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Sign Up"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                isLogin ? "Welcome Back 👋" : "Create Account 🚀",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// Name (Only for Sign Up)
              if (!isLogin)
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      onChanged: (val) => name = val,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              /// Email
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                onChanged: (val) => email = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter your email";
                  }
                  if (!val.contains('@')) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Password
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: obscurePassword,
                onChanged: (val) => password = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter password";
                  }
                  if (val.length < 6) {
                    return "Min 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Confirm Password (Sign Up only)
              if (!isLogin)
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      onChanged: (val) => confirmPassword = val,
                      validator: (val) {
                        if (val != password) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              const SizedBox(height: 10),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isLogin ? "Login" : "Sign Up"),
                ),
              ),

              const SizedBox(height: 20),

              /// Toggle Button
              TextButton(
                onPressed: toggleAuthMode,
                child: Text(
                  isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
