import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String baseUrl = "http://localhost/greetfarm_api/";

  static Future<List<dynamic>> getNotifications(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_notifications.php?user_id=$userId"),
      );
      final decoded = jsonDecode(response.body);
      return decoded["data"] ?? [];
    } catch (e) {
      return [];
    }
  }

  static Future<void> markAllRead(int userId) async {
    try {
      await http.post(
        Uri.parse("${baseUrl}mark_notifications_read.php"),
        body: {"user_id": userId.toString()},
      );
    } catch (e) {}
  }
}