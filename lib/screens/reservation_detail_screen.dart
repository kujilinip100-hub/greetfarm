import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../services/reservation_service.dart';
import '../widgets/status_badge.dart';

class ReservationDetailScreen extends StatefulWidget {
  final ReservationModel order;

  const ReservationDetailScreen({super.key, required this.order});

  @override
  State<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  bool isUpdating = false;
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.status;
  }

  Future<void> markAsReady() async {
    setState(() => isUpdating = true);

    final result = await ReservationService.updateOrderStatus(
      reservationId: widget.order.reservationId,
      status: "Ready",
    );

    setState(() => isUpdating = false);
    if (!mounted) return;

    if (result["status"] == "success") {
      setState(() => currentStatus = "Ready");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order marked as Ready for collection!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"]), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(title: const Text("Reservation Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        StatusBadge(status: currentStatus),
                      ],
                    ),
                    const Divider(height: 30),
                    _infoRow(Icons.eco, "Product", order.productName),
                    const SizedBox(height: 12),
                    _infoRow(Icons.scale, "Quantity", "${order.quantity} Kg"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (currentStatus == "Pending")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isUpdating ? null : markAsReady,
                  icon: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(isUpdating ? "Updating..." : "MARK AS READY"),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      currentStatus == "Collected"
                          ? "This order has been collected"
                          : "Waiting for customer to collect",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 10),
        Text("$label : ", style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}