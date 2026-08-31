import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'my_products_screen.dart';
import 'view_orders_screen.dart';
import 'harvest_calendar_screen.dart';
import 'qr_scanner_screen.dart';
import 'farmer_profile_screen.dart';
import '../services/product_service.dart';
//import '../services/reservation_service.dart';
import '../widgets/dashboard_tile.dart';
import 'demand_prediction_screen.dart';
import 'login_screen.dart';
import '../services/session.dart';
import '../services/notification_service.dart';
import 'notifications_screen.dart';
import 'sales_analytics_screen.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int productCount = 0;
  int pendingCount = 0;
  int unreadCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final products = await ProductService.getProducts(Session.userId!);
    final orders = await ProductService.getFarmerOrders(Session.userId!);
    final notifications = await NotificationService.getNotifications(Session.userId!);

    setState(() {
      productCount = products.length;
      pendingCount = orders.where((o) => o["status"] == "Pending").length;
      unreadCount = notifications.where((n) => n["is_read"].toString() == "0").length;
      isLoading = false;
    });
  }

  Future<void> refreshAndGo(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text("Farmer Dashboard"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => refreshAndGo(const NotificationsScreen()),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text("$unreadCount", style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.agriculture,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Farmer 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          isLoading
                              ? const Text(
                                  "Loading...",
                                  style: TextStyle(color: Colors.white70),
                                )
                              : Text(
                                  "$productCount Products • $pendingCount Pending Orders",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    DashboardTile(
                      icon: Icons.add_box_rounded,
                      title: "Add Product",
                      color: const Color(0xFF2E7D32),
                      onTap: () => refreshAndGo(const AddProductScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.inventory_2_rounded,
                      title: "My Products",
                      color: const Color(0xFF388E3C),
                      onTap: () => refreshAndGo(const MyProductsScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.shopping_bag_rounded,
                      title: "View Orders",
                      color: const Color(0xFFFF9800),
                      onTap: () => refreshAndGo(const ViewOrdersScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.calendar_month_rounded,
                      title: "Harvest Calendar",
                      color: const Color(0xFF43A047),
                      onTap: () => refreshAndGo(const HarvestCalendarScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.qr_code_scanner_rounded,
                      title: "QR Scanner",
                      color: const Color(0xFF00897B),
                      onTap: () => refreshAndGo(const QRScannerScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.person_rounded,
                      title: "Profile",
                      color: const Color(0xFF66BB6A),
                      onTap: () => refreshAndGo(const FarmerProfileScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.insights,
                      title: "Demand Prediction",
                      color: const Color(0xFF7B1FA2),
                      onTap: () => refreshAndGo(const DemandPredictionScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.bar_chart_rounded,
                      title: "Sales Analytics",
                      color: const Color(0xFF00695C),
                      onTap: () => refreshAndGo(const SalesAnalyticsScreen()),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}