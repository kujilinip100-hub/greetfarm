import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/cart_order_service.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

class CartQrScreen extends StatefulWidget {
  final String cartId;

  const CartQrScreen({super.key, required this.cartId});

  @override
  State<CartQrScreen> createState() => _CartQrScreenState();
}

class _CartQrScreenState extends State<CartQrScreen> {
  bool isLoading = true;
  List<dynamic> items = [];
  String collectionPoint = "";

  @override
  void initState() {
    super.initState();
    loadCartOrder();
  }

  Future<void> loadCartOrder() async {
    final result = await CartOrderService.getCartOrder(widget.cartId);
    if (result["status"] == "success") {
      items = result["items"] ?? [];
      if (items.isNotEmpty) {
        collectionPoint = items.first["collection_point"] ?? "";
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final qrData = "CART_ID:${widget.cartId}";

    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("collection_qr_title"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: QrImageView(data: qrData, version: QrVersions.auto, size: 200),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 18),
                        const SizedBox(width: 6),
                        Text(LanguageService.t("reservation_confirmed"), style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    LanguageService.t("show_qr_at_point"),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LanguageService.tCollectionPoint(collectionPoint),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  // ---------- Item list ----------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Column(
                      children: items.map((item) {
                        final name = getLocalizedProductName(item["image"], item["product_name"] ?? "", LanguageService.currentLang);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.eco_outlined, size: 18, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              Text("${item["quantity"]} Kg", style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.volunteer_activism, color: Colors.orange, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          LanguageService.t("thank_you_farmers"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home_outlined),
                      label: Text(LanguageService.t("back_to_dashboard")),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}