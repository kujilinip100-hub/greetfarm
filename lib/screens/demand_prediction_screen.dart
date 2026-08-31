import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class DemandPredictionScreen extends StatefulWidget {
  const DemandPredictionScreen({super.key});

  @override
  State<DemandPredictionScreen> createState() => _DemandPredictionScreenState();
}

class _DemandPredictionScreenState extends State<DemandPredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final inventoryController = TextEditingController();
  final unitsSoldController = TextEditingController();
  final unitsOrderedController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final competitorPriceController = TextEditingController();

  String selectedCategory = "Vegetables";
  String selectedRegion = "North";
  String selectedWeather = "Sunny";
  String selectedSeason = "Summer";
  bool promotion = false;
  bool epidemic = false;

  bool isLoading = false;
  double? predictedDemand;
  String? errorMessage;

  final Map<String, String> categoryDisplayToModel = {
  "Vegetables": "Groceries",
  "Fruits": "Groceries",
  "Grains": "Groceries",
  "Other Produce": "Groceries",
};

  List<String> get categories => categoryDisplayToModel.keys.toList();
  final List<String> regions = ["North", "South", "East", "West"];
  final List<String> weatherOptions = ["Sunny", "Rainy", "Cloudy", "Snowy"];
  final List<String> seasons = ["Summer", "Winter", "Spring", "Autumn"];

  Future<void> getPrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      predictedDemand = null;
      errorMessage = null;
    });

    final result = await AIService.predictDemand(
      category: categoryDisplayToModel[selectedCategory]!, // "Vegetables" → "Groceries"
      region: selectedRegion,
      inventoryLevel: double.parse(inventoryController.text),
      unitsSold: double.parse(unitsSoldController.text),
      unitsOrdered: double.parse(unitsOrderedController.text),
      price: double.parse(priceController.text),
      discount: double.parse(discountController.text),
      weather: selectedWeather,
      promotion: promotion,
      competitorPricing: double.parse(competitorPriceController.text),
      season: selectedSeason,
      epidemic: epidemic,
    );

    setState(() => isLoading = false);

    if (result["status"] == "success") {
      setState(() => predictedDemand = result["predicted_demand"]);
    } else {
      setState(() => errorMessage = result["message"]);
    }
  }

  @override
  void dispose() {
    inventoryController.dispose();
    unitsSoldController.dispose();
    unitsOrderedController.dispose();
    priceController.dispose();
    discountController.dispose();
    competitorPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demand Prediction")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.insights, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        "AI-powered demand forecast based on market conditions",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category & Region dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(labelText: "Category", prefixIcon: Icon(Icons.category_outlined)),
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => selectedCategory = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedRegion,
                      decoration: const InputDecoration(labelText: "Region", prefixIcon: Icon(Icons.map_outlined)),
                      items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (v) => setState(() => selectedRegion = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: inventoryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Inventory Level", prefixIcon: Icon(Icons.inventory_2_outlined)),
                validator: (v) => _validateNumber(v),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: unitsSoldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Units Sold", prefixIcon: Icon(Icons.sell_outlined)),
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: unitsOrderedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Units Ordered", prefixIcon: Icon(Icons.shopping_cart_outlined)),
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price (Rs)", prefixIcon: Icon(Icons.attach_money)),
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Discount %", prefixIcon: Icon(Icons.percent)),
                      validator: (v) => _validateNumber(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: competitorPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Competitor Pricing (Rs)", prefixIcon: Icon(Icons.compare_arrows)),
                validator: (v) => _validateNumber(v),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedWeather,
                      decoration: const InputDecoration(labelText: "Weather", prefixIcon: Icon(Icons.wb_sunny_outlined)),
                      items: weatherOptions.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                      onChanged: (v) => setState(() => selectedWeather = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedSeason,
                      decoration: const InputDecoration(labelText: "Season", prefixIcon: Icon(Icons.calendar_month_outlined)),
                      items: seasons.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => selectedSeason = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text("Promotion Active"),
                value: promotion,
                activeThumbColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => promotion = v),
              ),
              SwitchListTile(
                title: const Text("Epidemic/Outbreak Situation"),
                value: epidemic,
                activeThumbColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => epidemic = v),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : getPrediction,
                  icon: isLoading
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.auto_graph),
                  label: Text(isLoading ? "Predicting..." : "Predict Demand"),
                ),
              ),
              const SizedBox(height: 24),

              if (predictedDemand != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.green, size: 32),
                      const SizedBox(height: 10),
                      Text(
                        "Predicted Demand",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${predictedDemand!.toStringAsFixed(0)} units",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                      ),
                    ],
                  ),
                ),

              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(errorMessage!, style: TextStyle(color: Colors.red.shade700)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) return "Required";
    if (double.tryParse(value) == null) return "Enter a valid number";
    return null;
  }
}