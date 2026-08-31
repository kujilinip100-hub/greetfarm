import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;
  String selectedRole = "Customer";

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ApiService.register(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
      role: selectedRole,
      phone: phoneController.text.trim(),
      location: locationController.text.trim(),
    );

    setState(() => isLoading = false);
    if (!mounted) return;

    if (result["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"])),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"]), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: const Icon(Icons.person_add, size: 44, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(LanguageService.t("create_account"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: LanguageService.t("full_name"), prefixIcon: const Icon(Icons.badge_outlined)),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Enter full name" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: LanguageService.t("email"), prefixIcon: const Icon(Icons.email_outlined)),                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Enter email";
                  if (!v.contains("@")) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: LanguageService.t("phone"), prefixIcon: const Icon(Icons.phone_outlined)),                validator: (v) => (v == null || v.isEmpty) ? "Enter phone number" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: LanguageService.t("location"), prefixIcon: const Icon(Icons.location_on_outlined)),                validator: (v) => (v == null || v.isEmpty) ? "Enter location" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: LanguageService.t("username"), prefixIcon: const Icon(Icons.person_outline)),                validator: (v) => (v == null || v.trim().isEmpty) ? "Enter username" : null,
              ),
              const SizedBox(height: 16),

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
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter password";
                  if (v.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(LanguageService.t("register_as"), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),              ),
              const SizedBox(height: 10),

                            Row(
                children: [
                  Expanded(
                    child: _roleCard(
                      "Farmer",
                      Icons.agriculture,
                      LanguageService.t("farmer"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _roleCard(
                      "Customer",
                      Icons.shopping_basket,
                      LanguageService.t("customer"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(LanguageService.t("register").toUpperCase()),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LanguageService.t("already_account")),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(LanguageService.t("login_link"), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _roleCard(String role, IconData icon, String displayLabel) {
    final isSelected = selectedRole == role;
    return InkWell(
      onTap: () => setState(() => selectedRole = role),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.green : Colors.grey.shade500, size: 26),
            const SizedBox(height: 6),
            Text(
              displayLabel,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.green.shade800 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}