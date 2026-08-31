import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<Map<String, dynamic>> addProduct({
    required int farmerId,
    required String productName,
    required String category,
    required String price,
    required String quantity,
    required String harvestDate,
    required String image,
    required int distanceKm,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}add_product.php"),
        body: {
          "farmer_id": farmerId.toString(),
          "product_name": productName,
          "category": category,
          "price": price,
          "quantity": quantity,
          "harvest_date": harvestDate,
          "image": image,
          "distance_km": distanceKm.toString(),
        },
      );

      if (response.statusCode != 200) {
        return {
          "status": "error",
          "message": "Server Error",
        };
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }

  static Future<List<dynamic>> getProducts(int farmerId) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_products.php?farmer_id=$farmerId"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getAvailableProducts() async {
  try {
    final response = await http.get(
      Uri.parse("${baseUrl}get_available_products.php"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

  static Future<Map<String, dynamic>> updateProduct({
    required int productId,
    required String productName,
    required String category,
    required String price,
    required String quantity,
    required String harvestDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}update_product.php"),
        body: {
          "product_id": productId.toString(),
          "product_name": productName,
          "category": category,
          "price": price,
          "quantity": quantity,
          "harvest_date": harvestDate,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}delete_product.php"),
        body: {
          "product_id": productId.toString(),
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }

  static Future<List<dynamic>> getFarmerOrders(int farmerId) async {
    final response = await http.get(
      Uri.parse("${baseUrl}get_farmer_orders.php?farmer_id=$farmerId"),
    );

    final decoded = jsonDecode(response.body);
    return decoded["data"];
  }
}