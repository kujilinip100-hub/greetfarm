import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  // ===========================
  // REGISTER API
  // ===========================
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String role,
    required String phone,
    required String location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}register.php"),
        body: {
          "full_name": fullName,
          "email": email,
          "username": username,
          "password": password,
          "role": role,
          "phone": phone,
          "location": location,
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
        "message": "Connection failed: $e",
      };
    }
  }

  // ===========================
  // LOGIN API
  // ===========================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}login.php"),
        body: {
          "username": username,
          "password": password,
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
        "message": "Connection failed: $e",
      };
    }
  }

  // ===========================
  // GET PRODUCTS API
  // ===========================
  static Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_products.php"),
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
        "message": "Connection failed: $e",
      };
    }
  }
}