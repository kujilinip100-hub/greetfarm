import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/cart_order_service.dart';
import '../services/session.dart';
import '../services/language_service.dart';
import 'cart_qr_screen.dart';

class CartCollectionPointScreen extends StatefulWidget {
  const CartCollectionPointScreen({super.key});

  @override
  State<CartCollectionPointScreen> createState() => _CartCollectionPointScreenState();
}

class _CartCollectionPointScreenState extends State<CartCollectionPointScreen> {
  final List<String> collectionPoints = [
    "Jaffna Collection Center",
    "Vavuniya Collection Center",
    "Kilinochi Collection Center",
    "Mannar Collection Center",
    "Trincomalee Collection Center",
  ];

  int? selectedIndex;
  bool isSubmitting = false;

  Future<void> submitOrder() async {
    if (selectedIndex == null) return;
    setState(() => isSubmitting = true);

    final result = await CartOrderService.createCartOrder(
      customerId: Session.userId!,
      collectionPoint: collectionPoints[selectedIndex!],
      items: CartService.items,
    );

    if (!mounted) return;
    setState(() => isSubmitting = false);

    if (result["status"] == "success") {
      final cartId = result["cart_id"];
      CartService.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CartQrScreen(cartId: cartId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Error"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("collection_point_title"))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(
                    "${CartService.itemCount} items • Rs.${CartService.grandTotal.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(LanguageService.t("select_collection_point"), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: collectionPoints.length,
                itemBuilder: (context, index) {
                  final name = collectionPoints[index];
                  final isSelected = selectedIndex == index;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected ? Colors.green.withOpacity(0.1) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: isSelected ? Colors.green : Colors.transparent, width: 2),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.location_on_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                        LanguageService.tCollectionPoint(name),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: () => setState(() => selectedIndex = index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedIndex == null || isSubmitting ? null : submitOrder,
                child: isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(LanguageService.t("continue_btn")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}