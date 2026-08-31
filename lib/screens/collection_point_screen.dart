import 'package:flutter/material.dart';
import 'collection_qr_screen.dart';
import '../services/reservation_service.dart';
import '../services/session.dart';

class CollectionPointScreen extends StatefulWidget {
  final String orderId;
  final int productId; // ✅ புது field
  final String productName;
  final double quantity;

  const CollectionPointScreen({
    super.key,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  @override
  State<CollectionPointScreen> createState() => _CollectionPointScreenState();
}

class _CollectionPointScreenState extends State<CollectionPointScreen> {
  final List<Map<String, String>> collectionPoints = [
    {"name": "Jaffna Collection Center", "distance": "2 Km Away"},
    {"name": "Vavuniya Collection Center", "distance": "5 Km Away"},
    {"name": "Kilinochi Collection Center", "distance": "7 Km Away"},
    {"name": "Mannar Collection Center", "distance": "10 Km Away"},
    {"name": "Trincomalee Collection Center", "distance": "12 Km Away"},
  ];

  int? selectedIndex;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection Point")),
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
                  const Icon(Icons.eco, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${widget.productName} • ${widget.quantity.toStringAsFixed(1)} Kg",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Select Collection Point", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: collectionPoints.length,
                itemBuilder: (context, index) {
                  final point = collectionPoints[index];
                  final isSelected = selectedIndex == index;

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
                      title: Text(point["name"]!, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(point["distance"]!),
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

                        final result = await ReservationService.reserveProduct(
                          customerId: Session.userId!,
                          productId: widget.productId,
                          quantity: widget.quantity,
                          collectionPoint: collectionPoints[selectedIndex!]["name"]!,
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
                                quantity: widget.quantity,
                                collectionPoint: collectionPoints[selectedIndex!]["name"]!,
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
                    : const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}