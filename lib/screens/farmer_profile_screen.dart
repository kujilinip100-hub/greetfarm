import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/profile_service.dart';
import '../services/session.dart';
import '../services/language_service.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedLocation = "Jaffna";
  final List<String> locations = [
    "Jaffna",
    "Vavuniya",
    "Kilinochi",
    "Mannar",
    "Mullaitivu",
    "Trincomalee",
    "Batticaloa"
  ];

  bool isEditing = false;
  bool isLoading = true;
  bool isGettingLocation = false;

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
      SnackBar(content: Text(result["message"] ?? LanguageService.t("profile_updated"))),
    );
  }

  // Farmer-oda real GPS location-a eduthu, database-la save pannurom
  Future<void> updateFarmLocation() async {
    setState(() => isGettingLocation = true);

    try {
      // Location permission check pannurom
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() => isGettingLocation = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LanguageService.t("location_error")), backgroundColor: Colors.red),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      final result = await ProfileService.updateLocation(
        userId: Session.userId!,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;
      setState(() => isGettingLocation = false);

      if (result["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LanguageService.t("location_updated")), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"] ?? LanguageService.t("location_error")), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => isGettingLocation = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t("location_error")), backgroundColor: Colors.red),
      );
    }
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
        title: Text(LanguageService.t("farmer_profile_title")),
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
                    child: const Icon(Icons.agriculture, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nameController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("name"),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    enabled: isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("phone_number"),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedLocation,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("location_label"),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    items: locations
                        .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                        .toList(),
                    onChanged: isEditing
                        ? (value) => setState(() => selectedLocation = value!)
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // ---------- GPS Location Button ----------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.gps_fixed, color: Colors.blue, size: 28),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            onPressed: isGettingLocation ? null : updateFarmLocation,
                            icon: isGettingLocation
                                ? const SizedBox(
                                    height: 18, width: 18,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.my_location, color: Colors.white),
                            label: Text(
                              isGettingLocation ? LanguageService.t("getting_location") : LanguageService.t("update_farm_location"),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}