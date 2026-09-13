import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import '../widgets/product_image_helper.dart';

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
      appBar: AppBar(title: Text(LanguageService.t("edit_product_title"))),
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
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: ClipOval(
                      child: ProductImageHelper.getImage(widget.product.image, size: 34),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "${LanguageService.t("editing_prefix")}: ${getLocalizedProductName(widget.product.image, widget.product.productName, LanguageService.currentLang)}",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: LanguageService.t("product_name"), prefixIcon: const Icon(Icons.eco_outlined)),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: LanguageService.t("category"), prefixIcon: const Icon(Icons.category_outlined)),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: LanguageService.t("price_label"), prefixIcon: const Icon(Icons.attach_money)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: LanguageService.t("quantity_label"), prefixIcon: const Icon(Icons.scale_outlined)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: harvestController,
              decoration: InputDecoration(labelText: LanguageService.t("harvest_date"), prefixIcon: const Icon(Icons.calendar_today_outlined)),
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
                label: Text(isSubmitting ? LanguageService.t("updating") : LanguageService.t("update_product_btn")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}