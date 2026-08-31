import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'farmer_dashboard.dart';
import 'customer_dashboard.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import 'admin_dashboard.dart';
import '../services/language_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedLang = LanguageService.currentLang;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ApiService.login(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    setState(() => isLoading = false);
    if (!mounted) return;

        if (result["status"] == "success") {
      Session.userId = int.parse(result["user_id"].toString());
      Session.role = result["role"];
      Session.fullName = result["full_name"];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"])),
      );

      if (result["role"] == "Farmer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FarmerDashboard()),
        );
      } else if (result["role"] == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerDashboard()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"]), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<String>(
                      value: selectedLang,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: "en", child: Text("English")),
                        DropdownMenuItem(value: "ta", child: Text("தமிழ்")),
                        DropdownMenuItem(value: "si", child: Text("සිංහල")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLang = value!;
                          LanguageService.currentLang = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.agriculture, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    LanguageService.t("welcome"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LanguageService.t("tagline"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("username"),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? "Enter your username" : null,
                  ),
                  const SizedBox(height: 18),

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("password"),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Enter your password" : null,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(LanguageService.t("login")),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LanguageService.t("no_account")),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(LanguageService.t("register"), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}