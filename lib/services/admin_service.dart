import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_all_users.php"));
      final decoded = jsonDecode(response.body);
      return decoded["data"] ?? [];
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteUser(int userId) async {
    try {
      await http.post(
        Uri.parse("${baseUrl}delete_user.php"),
        body: {"user_id": userId.toString()},
      );
    } catch (e) {}
  }

  static Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_all_products_admin.php"));
      final decoded = jsonDecode(response.body);
      return decoded["data"] ?? [];
    } catch (e) {
      return [];
    }
  }
}