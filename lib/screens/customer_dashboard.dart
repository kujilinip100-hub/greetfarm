import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'my_orders_screen.dart';
import 'customer_profile_screen.dart';
import '../widgets/dashboard_tile.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import '../services/notification_service.dart';
import '../services/session.dart';
import 'spending_analytics_screen.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    loadUnreadCount();
  }

  Future<void> loadUnreadCount() async {
    final notifications = await NotificationService.getNotifications(Session.userId!);
    setState(() {
      unreadCount = notifications.where((n) => n["is_read"].toString() == "0").length;
    });
  }

  Future<void> openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
    loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Dashboard"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: openNotifications,
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
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.location_on, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nearby Farmers",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Fresh vegetables from local farmers",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
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
                      icon: Icons.storefront_rounded,
                      title: "Browse Products",
                      color: const Color(0xFF2E7D32),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductListScreen()),
                      ),
                    ),
                    DashboardTile(
                      icon: Icons.receipt_long_rounded,
                      title: "My Orders",
                      color: const Color(0xFFFF9800),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                      ),
                    ),
                    DashboardTile(
                      icon: Icons.person_rounded,
                      title: "Profile",
                      color: const Color(0xFF66BB6A),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerProfileScreen()),
                      ),
                    ),
                    DashboardTile(
                      icon: Icons.bar_chart_rounded,
                      title: "My Spending",
                      color: const Color(0xFFFF9800),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SpendingAnalyticsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}