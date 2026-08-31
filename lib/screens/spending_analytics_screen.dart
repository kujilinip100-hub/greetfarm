import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/session.dart';
import '../widgets/product_image_helper.dart';

class SpendingAnalyticsScreen extends StatefulWidget {
  const SpendingAnalyticsScreen({super.key});

  @override
  State<SpendingAnalyticsScreen> createState() => _SpendingAnalyticsScreenState();
}

class _SpendingAnalyticsScreenState extends State<SpendingAnalyticsScreen> {
  bool isLoading = true;
  List<dynamic> thisWeek = [];
  List<dynamic> thisMonth = [];
  List<dynamic> allTime = [];
  double grandTotal = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await AnalyticsService.getCustomerSpending(Session.userId!);
    if (result["status"] == "success") {
      setState(() {
        thisWeek = result["this_week"] ?? [];
        thisMonth = result["this_month"] ?? [];
        allTime = result["all_time"] ?? [];
        grandTotal = double.tryParse(result["grand_total"].toString()) ?? 0;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Map<String, double> _weeklyChartData() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final Map<String, double> data = {};
    for (int i = 0; i < 7; i++) {
      final d = monday.add(Duration(days: i));
      final key = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      data[key] = 0;
    }
    for (final e in thisWeek) {
      final date = e["sale_date"].toString();
      final amt = double.tryParse(e["total_amount"].toString()) ?? 0;
      if (data.containsKey(date)) data[date] = (data[date] ?? 0) + amt;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final weekData = _weeklyChartData();
    final maxAmount = weekData.values.isEmpty
        ? 1.0
        : weekData.values.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);
    final dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4),
      appBar: AppBar(title: const Text("My Spending")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 32),
                        const SizedBox(height: 10),
                        const Text("Total Spent (All Time)", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          "Rs.${grandTotal.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("This Week", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (i) {
                          final key = weekData.keys.elementAt(i);
                          final value = weekData[key] ?? 0;
                          final barHeight = maxAmount == 0 ? 4.0 : (value / maxAmount) * 90;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (value > 0)
                                Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 9, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Container(
                                width: 22,
                                height: barHeight < 4 ? 4 : barHeight,
                                decoration: BoxDecoration(
                                  color: value > 0 ? const Color(0xFFFF9800) : Colors.grey.shade200,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(dayLabels[i], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Most Purchased (All Time)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (allTime.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("No completed purchases yet", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allTime.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final e = allTime[index];
                        final amt = double.tryParse(e["total_amount"].toString()) ?? 0;
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 62,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ProductImageHelper.getImage(e["image"], size: 50),
                              ),
                              const SizedBox(height: 4),
                              Text(e["product_name"] ?? "",
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                              Text("${e["total_qty"]} Kg", style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                              Text("Rs.${amt.toStringAsFixed(0)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9800), fontSize: 11)),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  const Text("This Month (by week)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (thisMonth.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("No purchases this month yet", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    )
                  else
                    ...thisMonth.map((e) => _spendTile(
                          image: e["image"],
                          title: "${e["product_name"]}",
                          subtitle: "${e["week_start"]} to ${e["week_end"]} • ${e["total_qty"]} Kg",
                          amount: e["total_amount"],
                        )),
                ],
              ),
            ),
    );
  }

  Widget _spendTile({required dynamic image, required String title, required String subtitle, required dynamic amount}) {
    final amt = double.tryParse(amount.toString()) ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: ProductImageHelper.getImage(image, size: 36)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text("Rs.${amt.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9800))),
        ],
      ),
    );
  }
}