import 'package:flutter/material.dart';
import '../services/reservation_service.dart';
import '../services/product_service.dart';
import '../services/session.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import 'qr_camera_screen.dart';

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

    final validIds = readyOrders.map((o) => int.parse(o["reservation_id"].toString())).toSet();
    if (selectedReservationId != null && !validIds.contains(selectedReservationId)) {
      selectedReservationId = null;
    }

    setState(() => isLoading = false);
  }

  // Camera scanner open pannurom, scan aana QR data-a process pannurom
  Future<void> openCameraScanner() async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrCameraScreen()),
    );

    if (scannedCode == null || !mounted) return;

    // Pattern 1: Single order QR — "ORDER_ID:5"
    final orderMatch = RegExp(r"^ORDER_ID:(\d+)$").firstMatch(scannedCode);
    if (orderMatch != null) {
      final scannedId = int.parse(orderMatch.group(1)!);
      final match = readyOrders.where((o) => int.parse(o["reservation_id"].toString()) == scannedId).toList();
      if (match.isNotEmpty) {
        setState(() => selectedReservationId = scannedId);
        _showSnack(LanguageService.t("order_found"), Colors.green);
      } else {
        _showSnack(LanguageService.t("invalid_qr"), Colors.red);
      }
      return;
    }

    // Pattern 2: Cart QR — "CART_ID:CART20260101123"
    final cartMatch = RegExp(r"^CART_ID:(.+)$").firstMatch(scannedCode);
    if (cartMatch != null) {
      final cartId = cartMatch.group(1)!;
      final matchingItems = readyOrders.where((o) => o["cart_id"] == cartId).toList();
      if (matchingItems.isNotEmpty) {
        // Andha cart-la, IDHU farmer-oda irukra ella items-um select pannurom
        // (single item-a select pannina maadhiri, aana idhu multiple)
        await _confirmCartItems(matchingItems);
      } else {
        _showSnack(LanguageService.t("invalid_qr"), Colors.red);
      }
      return;
    }

    _showSnack(LanguageService.t("invalid_qr"), Colors.red);
  }

  Future<void> _confirmCartItems(List<dynamic> items) async {
    setState(() => isConfirming = true);
    for (final item in items) {
      await ReservationService.updateOrderStatus(
        reservationId: int.parse(item["reservation_id"].toString()),
        status: "Collected",
      );
    }
    if (!mounted) return;
    setState(() => isConfirming = false);
    _showSnack(LanguageService.t("order_marked_collected"), Colors.green);
    loadReadyOrders();
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
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
        SnackBar(content: Text(LanguageService.t("order_marked_collected"))),
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
      appBar: AppBar(title: Text(LanguageService.t("qr_scanner_title"))),
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
                  Text(LanguageService.t("scan_customer_qr"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    LanguageService.t("after_scan_confirm"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // ---------- Real Camera Scan Button ----------
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: openCameraScanner,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(LanguageService.t("scan_qr_camera_btn")),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LanguageService.t("or_manual_select"),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),

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
                          Text(LanguageService.t("no_orders_ready"), style: TextStyle(color: Colors.orange.shade700)),
                        ],
                      ),
                    )
                  else ...[
                    DropdownButtonFormField<int>(
                      key: ValueKey(readyOrders.length),
                      value: selectedReservationId,
                      decoration: InputDecoration(
                        labelText: LanguageService.t("select_order_simulate"),
                        prefixIcon: const Icon(Icons.receipt_long_outlined),
                      ),
                      items: readyOrders
                          .map<DropdownMenuItem<int>>((o) => DropdownMenuItem(
                                value: int.parse(o["reservation_id"].toString()),
                                child: Text(
                                  "${getLocalizedProductName(o["image"], o["product_name"], LanguageService.currentLang)} - ${o["customer_name"]}",
                                ),
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
                        label: Text(isConfirming ? LanguageService.t("confirming") : LanguageService.t("confirm_collection")),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}