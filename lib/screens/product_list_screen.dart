import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image_helper.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import 'product_details_screen.dart';
import '../services/cart_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;

  String searchQuery = "";
  int? selectedMaxDistance;
  final List<int?> distanceFilterOptions = [null, 2, 5, 10, 20];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await ProductService.getAvailableProducts();
    products = result.map((e) => ProductModel.fromJson(e)).toList();
    _applyFilters();
    setState(() => isLoading = false);
  }

  void _applyFilters() {
    filteredProducts = products.where((product) {
      final matchesSearch =
          product.productName.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesDistance =
          selectedMaxDistance == null || product.distanceKm <= selectedMaxDistance!;

      return matchesSearch && matchesDistance;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("fresh_products"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _applyFilters();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: LanguageService.t("search_products"),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButtonFormField<int?>(
                    initialValue: selectedMaxDistance,
                    decoration: InputDecoration(
                      labelText: LanguageService.t("filter_distance"),
                      prefixIcon: const Icon(Icons.social_distance_outlined),
                    ),
                    items: distanceFilterOptions
                        .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text(d == null ? LanguageService.t("all_distances") : "Within $d Km"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMaxDistance = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          message: LanguageService.t("no_products_found"),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image section - top of the box
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.08),
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: ProductImageHelper.getImage(product.image, size: 90),
                                            ),
                                            // Distance badge - top right corner
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.location_on, size: 12, color: Colors.blue),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      "${product.distanceKm}km",
                                                      style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Info section - bottom of the box
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getLocalizedProductName(product.image, product.productName, LanguageService.currentLang),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${product.quantity.toStringAsFixed(1)} ${LanguageService.t("kg_available")}",
                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                          ),
                                                                                    const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Rs.${product.price}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E7D32),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  CartService.addToCart(product, 0.5);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(LanguageService.t("added_to_cart")),
                                                      duration: const Duration(seconds: 1),
                                                    ),
                                                  );
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF2E7D32),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.add_shopping_cart, size: 14, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}