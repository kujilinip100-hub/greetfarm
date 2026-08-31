import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<Map<String, dynamic>> reserveProduct({
    required int customerId,
    required int productId,
    required double quantity,
    required String collectionPoint,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}reserve_product.php"),
        body: {
          "customer_id": customerId.toString(),
          "product_id": productId.toString(),
          "quantity": quantity.toString(),
          "collection_point": collectionPoint,
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

  static Future<List<dynamic>> getReservations(int farmerId) async {
    final response = await http.get(
      Uri.parse("${baseUrl}get_reservations.php"),
    );

    print(response.body);

    final data = jsonDecode(response.body);

    return data["data"];
  }

  static Future<List<dynamic>> getCustomerOrders(int customerId) async {
    final response = await http.get(
      Uri.parse("${baseUrl}get_customer_orders.php?customer_id=$customerId"),
    );

    final decoded = jsonDecode(response.body);
    return decoded["data"];
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required int reservationId,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}update_order_status.php"),
        body: {
          "reservation_id": reservationId.toString(),
          "status": status,
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}