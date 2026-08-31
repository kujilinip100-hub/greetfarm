import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController harvestController;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.productName);
    categoryController = TextEditingController(text: widget.product.category);
    priceController = TextEditingController(text: widget.product.price.toString());
    quantityController = TextEditingController(text: widget.product.quantity.toString());
    harvestController = TextEditingController(text: widget.product.harvestDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    harvestController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    setState(() => isSubmitting = true);

    final result = await ProductService.updateProduct(
      productId: widget.product.productId,
      productName: nameController.text.trim(),
      category: categoryController.text.trim(),
      price: priceController.text.trim(),
      quantity: quantityController.text.trim(),
      harvestDate: harvestController.text.trim(),
    );

    if (!mounted) return;
    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"])),
    );

    if (result["status"] == "success") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.eco, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Editing: ${widget.product.productName}",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name", prefixIcon: Icon(Icons.eco_outlined)),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category", prefixIcon: Icon(Icons.category_outlined)),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price", prefixIcon: Icon(Icons.attach_money)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity", prefixIcon: Icon(Icons.scale_outlined)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: harvestController,
              decoration: const InputDecoration(labelText: "Harvest Date", prefixIcon: Icon(Icons.calendar_today_outlined)),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : updateProduct,
                icon: isSubmitting
                    ? const SizedBox(
                        height: 18, width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(isSubmitting ? "Updating..." : "UPDATE PRODUCT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}