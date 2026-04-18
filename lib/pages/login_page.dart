import 'package:flutter/material.dart';
import '../database/auth_service.dart';

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

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        // LOGIN
        final storedEmail = await AuthManager.getEmail();
        final storedPassword = await AuthManager.getPassword();
        final storedName = await AuthManager.getName();

        if (email == storedEmail && password == storedPassword) {
          await AuthManager.saveLogin(
            email: email,
            name: storedName ?? "User",
          );

          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        }
      } else {
        // SIGN UP
        await AuthManager.registerUser(
          name: name,
          email: email,
          password: password,
        );

        await AuthManager.saveLogin(
          email: email,
          name: name,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                isLogin ? "Welcome Back 👋" : "Create Account 🚀",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (!isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  onChanged: (val) => name = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter name" : null,
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => email = val,
                validator: (val) => val == null || !val.contains("@")
                    ? "Enter valid email"
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: obscurePassword,
                onChanged: (val) => password = val,
                validator: (val) =>
                    val == null || val.length < 6 ? "Min 6 chars" : null,
              ),
              if (!isLogin)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                  onChanged: (val) => confirmPassword = val,
                  validator: (val) =>
                      val != password ? "Password not match" : null,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(isLogin ? "Login" : "Sign Up"),
              ),
              TextButton(
                onPressed: toggleMode,
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
