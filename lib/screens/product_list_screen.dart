import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:geolocator/geolocator.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image_helper.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';
import '../utils/distance_helper.dart';
import 'product_details_screen.dart';

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

  final TextEditingController searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  // Customer-oda real GPS location (kidaicha)
  double? customerLat;
  double? customerLng;

  @override
  void initState() {
    super.initState();
    loadProducts();
    _initSpeech();
    _getCustomerLocation();
  }

  // Speech recognition-a ஒரு முறை initialize pannurom
  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    setState(() {});
  }

  // Customer-oda current GPS location silent-ah eduthukirom
  // (permission illainala, illa error vandhalum, manual distance-ku fallback aagum)
  Future<void> _getCustomerLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return; // Manual distance-e fallback aagum
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        customerLat = position.latitude;
        customerLng = position.longitude;
      });
      _applyFilters();
    } catch (e) {
      // Location edukka mudiyalaina, problem illa -- manual distance fallback aagum
    }
  }

  // Product-oda display distance-a return pannum:
  // Farmer real GPS vachirundha + customer location kidaicha -> REAL distance
  // Illainala -> farmer manual-ah type pannina distance_km (fallback)
  double _getDisplayDistance(ProductModel product) {
    if (customerLat != null &&
        customerLng != null &&
        product.farmerLat != null &&
        product.farmerLng != null) {
      return calculateDistanceKm(customerLat!, customerLng!, product.farmerLat!, product.farmerLng!);
    }
    return product.distanceKm.toDouble();
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t("voice_not_available"))),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

        // Current app language-ku thakka correct voice recognition locale-a select pannurom
    String localeId = "en_US";
    if (LanguageService.currentLang == "ta") localeId = "ta_IN";
    if (LanguageService.currentLang == "si") localeId = "si_LK";

    setState(() => _isListening = true);
    await _speech.listen(
      localeId: localeId,
      onResult: (result) {
        setState(() {
          searchController.text = result.recognizedWords;
          searchQuery = result.recognizedWords;
          _applyFilters();
        });
      },
      onSoundLevelChange: null,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    final result = await ProductService.getAvailableProducts();
    products = result.map((e) => ProductModel.fromJson(e)).toList();
    _applyFilters();
    setState(() => isLoading = false);
  }

    void _applyFilters() {
    filteredProducts = products.where((product) {
      final matchesSearch = _matchesSearchQuery(product, searchQuery);

      final matchesDistance =
          selectedMaxDistance == null || _getDisplayDistance(product) <= selectedMaxDistance!;

      return matchesSearch && matchesDistance;
    }).toList();
  }

  // Product-oda English name, Tamil name, Sinhala name -- moondrum vachi check pannurom
  // (customer edhu language-la pesinalum, correct-ah match aagum)
  bool _matchesSearchQuery(ProductModel product, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase().trim();

    if (product.productName.toLowerCase().contains(q)) return true;

    final match = allProductImages.where(
      (img) => img.file.toLowerCase() == product.image.toLowerCase().trim(),
    ).toList();

    if (match.isNotEmpty) {
      final img = match.first;
      if (img.label.toLowerCase().contains(q)) return true;
      if (img.labelTa.toLowerCase().contains(q)) return true;
      if (img.labelSi.toLowerCase().contains(q)) return true;
    }

    return false;
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
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _applyFilters();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: LanguageService.t("search_products"),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none_outlined,
                          color: _isListening ? Colors.red : Colors.grey.shade600,
                        ),
                        onPressed: _toggleListening,
                      ),
                    ),
                  ),
                ),
                if (_isListening)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      LanguageService.t("listening"),
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
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
                            final displayDistance = _getDisplayDistance(product);
                            final isRealGps = customerLat != null && product.farmerLat != null;

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
                                                    Icon(
                                                      isRealGps ? Icons.gps_fixed : Icons.location_on,
                                                      size: 12,
                                                      color: isRealGps ? Colors.green : Colors.blue,
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      "${displayDistance.toStringAsFixed(1)}km",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: isRealGps ? Colors.green : Colors.blue,
                                                        fontWeight: FontWeight.w600,
                                                      ),
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