import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/session.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedLocation = "Jaffna";
  final List<String> locations = [
    "Jaffna", "Vavuniya", "Kilinochi", "Mannar",
    "Mullaitivu", "Trincomalee", "Batticaloa"
  ];

  bool isEditing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await ProfileService.getProfile(Session.userId!);
    if (result["status"] == "success") {
      final data = result["data"];
      nameController.text = data["full_name"] ?? "";
      phoneController.text = data["phone"] ?? "";
      if (locations.contains(data["location"])) {
        selectedLocation = data["location"];
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> saveProfile() async {
    final result = await ProfileService.updateProfile(
      userId: Session.userId!,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      location: selectedLocation,
    );

    setState(() => isEditing = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"] ?? "Profile updated!")),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () => isEditing ? saveProfile() : setState(() => isEditing = true),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nameController,
                    enabled: isEditing,
                    decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.badge_outlined)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    enabled: isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedLocation,
                    decoration: const InputDecoration(
                      labelText: "Nearby Collection Area",
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    items: locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                    onChanged: isEditing
                        ? (value) => setState(() => selectedLocation = value!)
                        : null,
                  ),
                ],
              ),
            ),
    );
  }
}