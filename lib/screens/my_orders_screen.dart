import 'package:flutter/material.dart';
import '../services/reservation_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';
import '../widgets/product_image_helper.dart';
import 'collection_qr_screen.dart';
import 'cart_qr_screen.dart';
import '../services/session.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

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

  // cart_id irukra orders-a group pannurom, illatha (single) orders-a
  // adhe madhiri vachukirom
  List<Map<String, dynamic>> _buildDisplayList() {
    final Map<String, List<dynamic>> grouped = {};
    final List<Map<String, dynamic>> display = [];

    for (final o in orders) {
      final cartId = o["cart_id"];
      if (cartId != null && cartId.toString().isNotEmpty) {
        grouped.putIfAbsent(cartId.toString(), () => []).add(o);
      } else {
        display.add({"isCart": false, "order": o, "sortId": int.parse(o["reservation_id"].toString())});
      }
    }

    grouped.forEach((cartId, items) {
      final maxId = items
          .map((i) => int.parse(i["reservation_id"].toString()))
          .reduce((a, b) => a > b ? a : b);
      display.add({"isCart": true, "cartId": cartId, "items": items, "sortId": maxId});
    });

    display.sort((a, b) => (b["sortId"] as int).compareTo(a["sortId"] as int));
    return display;
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _buildDisplayList();

    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("my_orders_title"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? EmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: LanguageService.t("no_orders_yet"),
                )
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final entry = displayList[index];
                      if (entry["isCart"] == true) {
                        return _cartOrderCard(entry["cartId"], entry["items"]);
                      } else {
                        return _singleOrderCard(entry["order"]);
                      }
                    },
                  ),
                ),
    );
  }

  // ---------- Multi-item (cart) order card ----------
  Widget _cartOrderCard(String cartId, List<dynamic> items) {
    final firstItem = items.first;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartQrScreen(cartId: cartId)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: ProductImageHelper.getImage(firstItem["image"], size: 30)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${items.length} ${LanguageService.t("kg_available").contains("items") ? "" : ""}${items.length > 1 ? "Items" : "Item"} • ${LanguageService.tCollectionPoint(firstItem["collection_point"])}",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.qr_code, size: 18, color: Colors.green),
                ],
              ),
              const Divider(height: 20),
              ...items.map((item) {
                final name = getLocalizedProductName(item["image"], item["product_name"] ?? "", LanguageService.currentLang);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text("$name (${item["quantity"]} Kg)", style: const TextStyle(fontSize: 13))),
                      StatusBadge(status: item["status"]),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.qr_code, size: 14, color: Colors.green.shade700),
                  const SizedBox(width: 4),
                  Text(
                    LanguageService.t("tap_show_qr"),
                    style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Single-item order card (original flow, backward compatible) ----------
  Widget _singleOrderCard(dynamic order) {
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
                      productImage: order["image"] ?? "",
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
                      getLocalizedProductName(order["image"], order["product_name"], LanguageService.currentLang),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${order["quantity"]} Kg • ${LanguageService.tCollectionPoint(order["collection_point"])}",
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
                            LanguageService.t("tap_show_qr"),
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
  }
}