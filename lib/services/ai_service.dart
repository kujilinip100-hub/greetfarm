import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Flask server localhost:5000-ல run ஆகுது (predict_api.py)
  // IMPORTANT: Flask server terminal-ல running-ஆ இருக்கணும்,
  // இல்லனா "Connection failed" error வரும்
  static const String baseUrl = "http://127.0.0.1:5000/";

  static Future<Map<String, dynamic>> predictDemand({
    required String category,
    required String region,
    required double inventoryLevel,
    required double unitsSold,
    required double unitsOrdered,
    required double price,
    required double discount,
    required String weather,
    required bool promotion,
    required double competitorPricing,
    required String season,
    required bool epidemic,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category": category,
          "region": region,
          "inventory_level": inventoryLevel,
          "units_sold": unitsSold,
          "units_ordered": unitsOrdered,
          "price": price,
          "discount": discount,
          "weather": weather,
          "promotion": promotion ? 1 : 0,
          "competitor_pricing": competitorPricing,
          "season": season,
          "epidemic": epidemic ? 1 : 0,
        }),
      );

      if (response.statusCode != 200) {
        return {
          "status": "error",
          "message": "Server returned error: ${response.statusCode}",
        };
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "status": "error",
        "message": "Could not connect to AI server. Flask server run ஆகுதா pாருங்க. Error: $e",
      };
    }
  }
}