class ProductModel {
  final int productId;
  final int farmerId;
  final String productName;
  final String category;
  final double price;
  final double quantity;
  final String harvestDate;
  final String image;
  final String status;
  final int distanceKm;
  final String farmerName;
  final double? farmerLat;
  final double? farmerLng;

  ProductModel({
    required this.productId,
    required this.farmerId,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    required this.harvestDate,
    required this.image,
    required this.status,
    this.distanceKm = 5,
    this.farmerName = "",
    this.farmerLat,
    this.farmerLng,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: int.parse(json["product_id"].toString()),
      farmerId: int.parse(json["farmer_id"].toString()),
      productName: json["product_name"],
      category: json["category"],
      price: double.parse(json["price"].toString()),
      quantity: double.parse(json["quantity"].toString()),
      harvestDate: json["harvest_date"],
      image: json["image"],
      status: json["status"],
      distanceKm: json["distance_km"] != null
          ? int.parse(json["distance_km"].toString())
          : 5,
      farmerName: json["farmer_name"] ?? "",
      farmerLat: json["farmer_lat"] != null ? double.tryParse(json["farmer_lat"].toString()) : null,
      farmerLng: json["farmer_lng"] != null ? double.tryParse(json["farmer_lng"].toString()) : null,
    );
  }
}