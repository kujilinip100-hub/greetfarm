import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product_model.dart';
import '../widgets/product_image_helper.dart';
import 'reserve_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  Future<void> _openInMaps(String locationName) async {
    final query = Uri.encodeComponent(locationName);
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: ProductImageHelper.getImage(
                              product.image,
                              size: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                                                const SizedBox(height: 6),
                        Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Sold by ${product.farmerName}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                Icons.attach_money,
                                "Price",
                                "Rs.${product.price}/kg",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                Icons.scale,
                                "Available",
                                "${product.quantity} Kg",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _statCard(
                          Icons.calendar_today,
                          "Harvest Date",
                          product.harvestDate,
                          fullWidth: true,
                        ),
                        const SizedBox(height: 12),
                        // Clickable Map Location Card
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openInMaps(
                              "${product.category} farmer Jaffna Sri Lanka"),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Farmer's Location",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Approximately ${product.distanceKm} Km away",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Tap to view on map",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.open_in_new,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: product.quantity <= 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ReserveProductScreen(product: product),
                          ),
                        );
                      },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(
                  product.quantity <= 0 ? "Out of Stock" : "Reserve Product",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String label,
    String value, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}