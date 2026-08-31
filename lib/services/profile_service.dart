import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_profile.php?user_id=$userId"),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}update_profile.php"),
        body: {
          "user_id": userId.toString(),
          "full_name": fullName,
          "phone": phone,
          "location": location,
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}