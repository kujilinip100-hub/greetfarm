import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

class CollectionQrScreen extends StatelessWidget {
  final String orderId;
  final String productName;
  final String productImage;
  final double quantity;
  final String collectionPoint;

  const CollectionQrScreen({
    super.key,
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.collectionPoint,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = "ORDER_ID:$orderId";

    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("collection_qr_title"))),
      body: Center(
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    _detailRow(Icons.confirmation_number_outlined, LanguageService.t("order_id_label"), orderId),
                    const Divider(height: 24),
                    _detailRow(
                      Icons.eco_outlined,
                      LanguageService.t("product_label"),
                      "${getLocalizedProductName(productImage, productName, LanguageService.currentLang)} - ${quantity.toStringAsFixed(1)} Kg",
                    ),
                    const Divider(height: 24),
                    _detailRow(
                      Icons.location_on_outlined,
                      LanguageService.t("collection_point_label"),
                      LanguageService.tCollectionPoint(collectionPoint),
                    ),

                    const SizedBox(height: 30),

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
                          const SizedBox(height: 4),
                          Text(
                            LanguageService.t("see_you_again"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}