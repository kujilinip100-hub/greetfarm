import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_service.dart';
import 'cart_service.dart';

class CartOrderService {
  static Future<Map<String, dynamic>> createCartOrder({
    required int customerId,
    required String collectionPoint,
    required List<CartItem> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ProductService.baseUrl}create_cart_order.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "customer_id": customerId,
          "collection_point": collectionPoint,
          "items": items
              .map((i) => {
                    "product_id": i.product.productId,
                    "quantity": i.quantity,
                  })
              .toList(),
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Connection error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getCartOrder(String cartId) async {
    try {
      final response = await http.get(
        Uri.parse("${ProductService.baseUrl}get_cart_order.php?cart_id=$cartId"),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Connection error: $e"};
    }
  }
}