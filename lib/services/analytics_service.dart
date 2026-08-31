import 'dart:convert';
import 'package:http/http.dart' as http;

class AnalyticsService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<Map<String, dynamic>> getSalesAnalytics(int farmerId) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_sales_analytics.php?farmer_id=$farmerId"),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getCustomerSpending(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_customer_spending.php?customer_id=$customerId"),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}