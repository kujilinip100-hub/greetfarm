import 'package:flutter/material.dart';
import 'collection_qr_screen.dart';
import '../services/reservation_service.dart';
import '../services/session.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import '../widgets/product_image_helper.dart';

class CollectionPointScreen extends StatefulWidget {
  final String orderId;
  final int productId;
  final String productName;
  final String productImage;
  final double quantity;

  const CollectionPointScreen({
    super.key,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
  });

  @override
  State<CollectionPointScreen> createState() => _CollectionPointScreenState();
}

class _CollectionPointScreenState extends State<CollectionPointScreen> {
  final List<Map<String, dynamic>> collectionPoints = [
    {"name": "Jaffna Collection Center", "distanceKm": 2},
    {"name": "Vavuniya Collection Center", "distanceKm": 5},
    {"name": "Kilinochi Collection Center", "distanceKm": 7},
    {"name": "Mannar Collection Center", "distanceKm": 10},
    {"name": "Trincomalee Collection Center", "distanceKm": 12},
  ];

  int? selectedIndex;
  bool isSubmitting = false;

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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: ProductImageHelper.getImage(widget.productImage, size: 30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${getLocalizedProductName(widget.productImage, widget.productName, LanguageService.currentLang)} • ${widget.quantity.toStringAsFixed(1)} Kg",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                  final point = collectionPoints[index];
                  final isSelected = selectedIndex == index;
                  final englishName = point["name"] as String;
                  final distanceKm = point["distanceKm"];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected ? Colors.green.withOpacity(0.1) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: isSelected ? Colors.green : Colors.transparent, width: 2),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.location_on_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                        LanguageService.tCollectionPoint(englishName),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("$distanceKm ${LanguageService.t("km_away")}"),
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
                onPressed: selectedIndex == null || isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);

                        final selectedPointName = collectionPoints[selectedIndex!]["name"] as String;

                        final result = await ReservationService.reserveProduct(
                          customerId: Session.userId!,
                          productId: widget.productId,
                          quantity: widget.quantity,
                          collectionPoint: selectedPointName,
                        );

                        if (!mounted) return;
                        setState(() => isSubmitting = false);

                        if (result["status"] == "success") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CollectionQrScreen(
                                orderId: result["order_id"].toString(),
                                productName: widget.productName,
                                productImage: widget.productImage,
                                quantity: widget.quantity,
                                collectionPoint: selectedPointName,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result["message"]), backgroundColor: Colors.red),
                          );
                        }
                      },
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