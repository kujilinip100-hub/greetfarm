import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/session.dart';
import '../data/product_images.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final harvestDateController = TextEditingController();
  final descriptionController = TextEditingController();

  // Distance selection variables
  int selectedDistance = 5;
  final List<int> distanceOptions = [1, 2, 3, 5, 10, 15, 20];

  bool isSubmitting = false;

  // Preset product images - filename + icon + display label
    final List<ProductImageData> presetImages = allProductImages;

  String selectedImage = "no_image.jpg";

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        String month = picked.month.toString().padLeft(2, '0');
        String day = picked.day.toString().padLeft(2, '0');
        harvestDateController.text = "${picked.year}-$month-$day";
      });
    }
  }

  Future<void> submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final result = await ProductService.addProduct(
      farmerId: Session.userId!,
      productName: nameController.text.trim(),
      category: categoryController.text.trim(),
      price: priceController.text.trim(),
      quantity: quantityController.text.trim(),
      harvestDate: harvestDateController.text.trim(),
      image: selectedImage,
      distanceKm: selectedDistance,
    );

    setState(() => isSubmitting = false);
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
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    harvestDateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.add_box_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        "List a new product for customers to discover",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name", prefixIcon: Icon(Icons.eco_outlined)),
                validator: (value) => (value == null || value.trim().isEmpty) ? "Product name is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category", prefixIcon: Icon(Icons.category_outlined)),
                validator: (value) => (value == null || value.trim().isEmpty) ? "Category is required" : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price (Rs)", prefixIcon: Icon(Icons.attach_money)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Required";
                        if (double.tryParse(value) == null) return "Invalid";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Quantity (Kg)", prefixIcon: Icon(Icons.scale_outlined)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return "Required";
                        if (double.tryParse(value) == null) return "Invalid";
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: harvestDateController,
                readOnly: true,
                onTap: pickDate,
                decoration: const InputDecoration(
                  labelText: "Harvest Date",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? "Select harvest date" : null,
              ),
              const SizedBox(height: 16),

              // Distance Dropdown Field
              DropdownButtonFormField<int>(
                initialValue: selectedDistance,
                decoration: const InputDecoration(
                  labelText: "Distance from Collection Point (Km)",
                  prefixIcon: Icon(Icons.social_distance_outlined),
                ),
                items: distanceOptions
                    .map((d) => DropdownMenuItem(value: d, child: Text("$d Km")))
                    .toList(),
                onChanged: (value) => setState(() => selectedDistance = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Product Description (Optional)",
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // ---------- Image Selector ----------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose Product Image",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presetImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final item = presetImages[index];
                  final isSelected = selectedImage == item.file;

                  return InkWell(
                    onTap: () => setState(() {
                      selectedImage = item.file;
                      if (item.asset.isNotEmpty) {
                        nameController.text = item.label;
                        categoryController.text = item.category;
                      }
                    }),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.withOpacity(0.15) : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                              child: item.asset == ""
                                ? Icon(Icons.image_not_supported_outlined, size: 30, color: Colors.grey.shade400)
                                : Image.asset(
                                    item.asset,
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.broken_image_outlined, size: 30, color: Colors.red.shade300),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isSubmitting ? null : submitProduct,
                  icon: isSubmitting
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline),
                  label: Text(isSubmitting ? "Adding..." : "Add Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}