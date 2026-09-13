import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../services/product_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';
import '../widgets/product_image_helper.dart';
import 'reservation_detail_screen.dart';
import '../services/session.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

class ViewOrdersScreen extends StatefulWidget {
  const ViewOrdersScreen({super.key});

  @override
  State<ViewOrdersScreen> createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  List<ReservationModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final result = await ProductService.getFarmerOrders(Session.userId!);
    orders = result.map<ReservationModel>((e) => ReservationModel.fromJson(e)).toList();
    setState(() => isLoading = false);
  }

  // cart_id vachi, evlo items ondre order-la irukku nu count pannurom
  Map<String, int> _cartCounts() {
    final Map<String, int> counts = {};
    for (final o in orders) {
      if (o.cartId != null && o.cartId!.isNotEmpty) {
        counts[o.cartId!] = (counts[o.cartId!] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final cartCounts = _cartCounts();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(title: Text(LanguageService.t("view_orders_title"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? EmptyState(icon: Icons.shopping_bag_outlined, message: LanguageService.t("no_orders_yet"))
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final isMultiItem = order.cartId != null &&
                          order.cartId!.isNotEmpty &&
                          (cartCounts[order.cartId!] ?? 0) > 1;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ReservationDetailScreen(order: order)),
                              );
                              loadOrders();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isMultiItem) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3F2FD),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.shopping_bag_rounded, size: 12, color: Color(0xFF1976D2)),
                                          const SizedBox(width: 5),
                                          Text(
                                            LanguageService.t("part_of_multi_order").replaceAll("{count}", "${cartCounts[order.cartId!]}"),
                                            style: const TextStyle(fontSize: 10.5, color: Color(0xFF1976D2), fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2E7D32).withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(child: ProductImageHelper.getImage(order.image, size: 40)),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    getLocalizedProductName(order.image, order.productName, LanguageService.currentLang),
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                StatusBadge(status: order.status),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    order.customerName,
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12.5),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Icon(Icons.scale_outlined, size: 14, color: Colors.grey.shade500),
                                                const SizedBox(width: 4),
                                                Text("${order.quantity} Kg", style: TextStyle(color: Colors.grey.shade700, fontSize: 12.5)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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