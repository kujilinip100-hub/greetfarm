import 'package:flutter/material.dart';
import '../services/reservation_service.dart';
import '../services/product_service.dart';
import '../services/session.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  List<dynamic> readyOrders = [];
  int? selectedReservationId;
  bool isLoading = true;
  bool isConfirming = false;

  @override
  void initState() {
    super.initState();
    loadReadyOrders();
  }

    Future<void> loadReadyOrders() async {
    final orders = await ProductService.getFarmerOrders(Session.userId!);
    readyOrders = orders.where((o) => o["status"] == "Ready").toList();

    // Selected ID-ஐ புது list-ல verify பண்றோம்
    // Illana adha reset பண்ணிடுவோம், dropdown crash ஆகாம இருக்க
    final validIds = readyOrders.map((o) => int.parse(o["reservation_id"].toString())).toSet();
    if (selectedReservationId != null && !validIds.contains(selectedReservationId)) {
      selectedReservationId = null;
    }

    setState(() => isLoading = false);
  }

  Future<void> confirmCollection() async {
    if (selectedReservationId == null) return;

    setState(() => isConfirming = true);

    final result = await ReservationService.updateOrderStatus(
      reservationId: selectedReservationId!,
      status: "Collected",
    );

    if (!mounted) return;
    setState(() => isConfirming = false);

    if (result["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order marked as Collected!")),
      );
      setState(() => selectedReservationId = null);
      loadReadyOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"]), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.qr_code_scanner, size: 70, color: Colors.green),
                  ),
                  const SizedBox(height: 24),
                  const Text("Scan Customer QR", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "After scanning, confirm product collection",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 30),

                  if (readyOrders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700),
                          const SizedBox(width: 10),
                          Text("No orders ready for collection", style: TextStyle(color: Colors.orange.shade700)),
                        ],
                      ),
                    )
                  else ...[
                    // key add பண்ணி, list refresh ஆனா dropdown state properly rebuild ஆகும்
                    DropdownButtonFormField<int>(
                      key: ValueKey(readyOrders.length),
                      value: selectedReservationId,
                      decoration: const InputDecoration(
                        labelText: "Select Order (simulate scan)",
                        prefixIcon: Icon(Icons.receipt_long_outlined),
                      ),
                      items: readyOrders
                          .map<DropdownMenuItem<int>>((o) => DropdownMenuItem(
                                value: int.parse(o["reservation_id"].toString()),
                                child: Text("${o["product_name"]} - ${o["customer_name"]}"),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => selectedReservationId = value),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: selectedReservationId == null || isConfirming ? null : confirmCollection,
                        icon: isConfirming
                            ? const SizedBox(
                                height: 18, width: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.check_circle_outline),
                        label: Text(isConfirming ? "Confirming..." : "Confirm Collection"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}