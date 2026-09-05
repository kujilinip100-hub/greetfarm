import 'package:flutter/material.dart';
import '../services/reservation_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';
import '../widgets/product_image_helper.dart';
import 'collection_qr_screen.dart';
import '../services/session.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    orders = await ReservationService.getCustomerOrders(Session.userId!);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: "No orders yet",
                )
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final status = order["status"];
                      final canShowQr = status == "Pending" || status == "Ready";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: canShowQr
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CollectionQrScreen(
                                        orderId: order["reservation_id"].toString(),
                                        productName: order["product_name"],
                                        quantity: double.tryParse(order["quantity"].toString()) ?? 0,
                                        collectionPoint: order["collection_point"],
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: ProductImageHelper.getImage(
                                      order["image"],
                                      size: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${order["product_name"]}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${order["quantity"]} Kg • ${order["collection_point"]}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (canShowQr) ...[
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.qr_code, size: 14, color: Colors.green.shade700),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Tap to show QR",
                                              style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                StatusBadge(status: status),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}