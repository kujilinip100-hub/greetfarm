import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../services/product_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';
import 'reservation_detail_screen.dart';
import '../services/session.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Orders")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const EmptyState(icon: Icons.shopping_bag_outlined, message: "No Orders Yet")
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.productName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    StatusBadge(status: order.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Text(order.customerName, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.scale_outlined, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Text("${order.quantity} Kg", style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                                  ],
                                ),
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