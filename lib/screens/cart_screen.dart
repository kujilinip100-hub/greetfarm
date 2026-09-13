import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import '../widgets/product_image_helper.dart';
import '../widgets/empty_state.dart';
import 'cart_collection_point_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increment(CartItem item) {
    setState(() {
      CartService.updateQuantity(item.product.productId, item.quantity + 0.5);
    });
  }

  void _decrement(CartItem item) {
    setState(() {
      CartService.updateQuantity(item.product.productId, item.quantity - 0.5);
    });
  }

  void _remove(CartItem item) {
    setState(() {
      CartService.removeFromCart(item.product.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("cart_title"))),
      body: items.isEmpty
          ? EmptyState(icon: Icons.shopping_cart_outlined, message: LanguageService.t("cart_empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = getLocalizedProductName(
                        item.product.image,
                        item.product.productName,
                        LanguageService.currentLang,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(child: ProductImageHelper.getImage(item.product.image, size: 42)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                    const SizedBox(height: 4),
                                    Text("Rs.${item.product.price} / kg", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _qtyButton(Icons.remove, () => _decrement(item)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text("${item.quantity.toStringAsFixed(1)} Kg",
                                              style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ),
                                        _qtyButton(Icons.add, () => _increment(item)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _remove(item),
                                  ),
                                  Text("Rs.${item.subtotal.toStringAsFixed(0)}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LanguageService.t("cart_total"), style: const TextStyle(fontSize: 16, color: Colors.grey)),
                            Text("Rs.${CartService.grandTotal.toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CartCollectionPointScreen()),
                              );
                            },
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: Text(LanguageService.t("proceed_checkout")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
      ),
    );
  }
}