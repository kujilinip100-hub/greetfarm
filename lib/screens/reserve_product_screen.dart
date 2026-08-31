import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'collection_point_screen.dart';
import '../widgets/product_image_helper.dart';

class ReserveProductScreen extends StatefulWidget {
  final ProductModel product;

  const ReserveProductScreen({super.key, required this.product});

  @override
  State<ReserveProductScreen> createState() => _ReserveProductScreenState();
}

class _ReserveProductScreenState extends State<ReserveProductScreen> {
  double? selectedQuantity;
  late List<double> quantityOptions;

  @override
  void initState() {
    super.initState();
    quantityOptions = _buildQuantityOptions(widget.product.quantity.toDouble());
    if (quantityOptions.isNotEmpty) {
      selectedQuantity = quantityOptions.first;
    }
  }

  // Available stock-ஐ வெச்சு, 0.5kg steps-ல dropdown options generate பண்றோம்
  // எ.கா: stock 2kg இருந்தா → [0.5, 1.0, 1.5, 2.0]
  List<double> _buildQuantityOptions(double maxStock) {
    List<double> options = [];
    double value = 0.5;
    while (value <= maxStock) {
      options.add(value);
      value += 0.5;
    }
    return options;
  }

  void reserveProduct() {
    if (selectedQuantity == null) return;

    const orderId = "ORD001";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionPointScreen(
          orderId: orderId,
          productId: widget.product.productId,
          productName: widget.product.productName,
          quantity: selectedQuantity!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: const Text("Reserve Product")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: ClipOval(
                      child: ProductImageHelper.getImage(product.image, size: 40),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.productName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Rs.${product.price} / kg", style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: Colors.green),
                  const SizedBox(width: 10),
                  Text("Available Quantity", style: TextStyle(color: Colors.grey.shade700)),
                  const Spacer(),
                  Text("${product.quantity} Kg",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (quantityOptions.isEmpty)
              const Text("Not enough stock available", style: TextStyle(color: Colors.red))
            else
              DropdownButtonFormField<double>(
                initialValue: selectedQuantity,
                decoration: const InputDecoration(
                  labelText: "Select Quantity (Kg)",
                  prefixIcon: Icon(Icons.scale_outlined),
                ),
                items: quantityOptions
                    .map((q) => DropdownMenuItem(value: q, child: Text("${q.toStringAsFixed(1)} Kg")))
                    .toList(),
                onChanged: (value) => setState(() => selectedQuantity = value),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: (selectedQuantity == null) ? null : reserveProduct,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text("Reserve Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}