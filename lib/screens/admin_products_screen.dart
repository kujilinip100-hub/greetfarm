import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../services/product_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image_helper.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await AdminService.getAllProducts();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const EmptyState(icon: Icons.inventory_2_outlined, message: "No products found")
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ProductImageHelper.getImage(p["image"], size: 44),
                        title: Text(p["product_name"] ?? ""),
                        subtitle: Text("Farmer: ${p["farmer_name"] ?? ""} • ${p["status"] ?? ""}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Remove Listing"),
                                content: Text("Remove ${p["product_name"]} permanently?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ProductService.deleteProduct(int.parse(p["product_id"].toString()));
                              loadProducts();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}