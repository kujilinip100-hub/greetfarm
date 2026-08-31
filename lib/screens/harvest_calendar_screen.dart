import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/product_image_helper.dart';
import '../services/session.dart';

class HarvestCalendarScreen extends StatefulWidget {
  const HarvestCalendarScreen({super.key});

  @override
  State<HarvestCalendarScreen> createState() => _HarvestCalendarScreenState();
}

class _HarvestCalendarScreenState extends State<HarvestCalendarScreen> {
  List<ProductModel> products = [];
  bool isLoading = true;

  // இப்போ காட்டப்படுற month
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await ProductService.getProducts(Session.userId!);
    products = result.map((e) => ProductModel.fromJson(e)).toList();
    setState(() => isLoading = false);
  }

  // "2026-08-04" string-ஐ DateTime ஆ மாத்தும் helper
  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  // ஒரு குறிப்பிட்ட date-ல harvest இருக்குற products-ஐ திருப்பும்
  List<ProductModel> _productsOnDate(DateTime date) {
    return products.where((p) {
      final harvestDate = _parseDate(p.harvestDate);
      if (harvestDate == null) return false;
      return harvestDate.year == date.year &&
          harvestDate.month == date.month &&
          harvestDate.day == date.day;
    }).toList();
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void _showDayDetails(DateTime date, List<ProductModel> dayProducts) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_monthName(date.month)} ${date.day}, ${date.year}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (dayProducts.isEmpty)
                const Text("No harvest scheduled on this date.")
              else
                ...dayProducts.map((product) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                              child: ProductImageHelper.getImage(product.image, size: 40),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${product.quantity} Kg • Rs.${product.price}/Kg",
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // இந்த month-ல எத்தனை நாட்கள் இருக்கு
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Month-ஓட முதல் நாள் எந்த weekday (0=Monday, 6=Sunday)
    final firstDayWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday - 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Harvest Calendar")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Month navigation header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.withOpacity(0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        "${_monthName(currentMonth.month)} ${currentMonth.year}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ),

                // Weekday labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                // Legend
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendDot(Colors.red, "Low Stock (\u22642 Kg)"),
                      const SizedBox(width: 14),
                      _legendDot(Colors.orange, "Limited (\u22645 Kg)"),
                      const SizedBox(width: 14),
                      _legendDot(Colors.green, "Good Stock"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Calendar grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: daysInMonth + firstDayWeekday,
                      itemBuilder: (context, index) {
                        // Month ஆரம்பிக்குமுன் empty cells
                        if (index < firstDayWeekday) {
                          return const SizedBox();
                        }

                        final day = index - firstDayWeekday + 1;
                        final date = DateTime(currentMonth.year, currentMonth.month, day);
                        final dayProducts = _productsOnDate(date);
                        final hasHarvest = dayProducts.isNotEmpty;

                        final isToday = date.year == DateTime.now().year &&
                            date.month == DateTime.now().month &&
                            date.day == DateTime.now().day;

                        // Andha day-ku irukra products-la, ethuvavathu low stock-ah irukka nu check pannurom
                        double lowestQuantity = 999999;
                        for (final p in dayProducts) {
                          if (p.quantity < lowestQuantity) lowestQuantity = p.quantity;
                        }

                        Color cellColor = Colors.transparent;
                        Color? borderColor;
                        if (hasHarvest) {
                          if (lowestQuantity <= 2) {
                            cellColor = Colors.red.withOpacity(0.15);
                            borderColor = Colors.red;
                          } else if (lowestQuantity <= 5) {
                            cellColor = Colors.orange.withOpacity(0.15);
                            borderColor = Colors.orange;
                          } else {
                            cellColor = Colors.green.withOpacity(0.12);
                          }
                        }

                        return InkWell(
                          onTap: () => _showDayDetails(date, dayProducts),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(10),
                              border: borderColor != null
                                  ? Border.all(color: borderColor, width: 1.5)
                                  : (isToday ? Border.all(color: Colors.green, width: 1.5) : null),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (hasHarvest)
                                  ProductImageHelper.getImage(
                                    dayProducts.first.image,
                                    size: 24,
                                  )
                                else
                                  const SizedBox(height: 24),
                                const SizedBox(height: 4),
                                Text(
                                  "$day",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: hasHarvest ? FontWeight.bold : FontWeight.normal,
                                    color: hasHarvest ? const Color(0xFF2E7D32) : Colors.black87,
                                  ),
                                ),
                                if (dayProducts.length > 1)
                                  Text(
                                    "+${dayProducts.length - 1}",
                                    style: const TextStyle(fontSize: 9, color: Colors.green),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
      ],
    );
  }
}