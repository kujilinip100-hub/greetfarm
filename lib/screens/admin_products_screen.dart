import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../services/product_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image_helper.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

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

  String _localizedStatus(String? status) {
    if (status == "Available") return LanguageService.t("status_available");
    if (status == "Sold Out") return LanguageService.t("status_soldout");
    return status ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("manage_products"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? EmptyState(icon: Icons.inventory_2_outlined, message: LanguageService.t("no_products_found_admin"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ProductImageHelper.getImage(p["image"], size: 44),
                        title: Text(getLocalizedProductName(p["image"], p["product_name"] ?? "", LanguageService.currentLang)),
                        subtitle: Text("${LanguageService.t("farmer_prefix")}: ${p["farmer_name"] ?? ""} • ${_localizedStatus(p["status"])}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(LanguageService.t("remove_listing_title")),
                                content: Text(LanguageService.t("remove_confirm_msg").replaceAll(
                                  "{name}",
                                  getLocalizedProductName(p["image"], p["product_name"] ?? "", LanguageService.currentLang),
                                )),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(LanguageService.t("cancel"))),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(LanguageService.t("delete"), style: const TextStyle(color: Colors.red))),
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