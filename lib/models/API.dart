import 'dart:convert';
import 'package:http/http.dart' as http;
import 'chart_data.dart'; // ✅ relative import (same folder)

class API {
  /// Fetches current market data for top 151 cryptocurrencies in INR
  static Future<List<dynamic>> getMarkets() async {
    try {
      final Uri url = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?"
            "vs_currency=inr&order=market_cap_desc&per_page=151&page=1&sparkline=false",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print("Failed to load market data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getMarkets: $e");
      return [];
    }
  }

  /// Fetches 7-day chart data for a specific cryptocurrency (coinId)
  static Future<ChartData?> getChartData(String coinId) async {
    try {
      final Uri url = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/$coinId/market_chart?"
            "vs_currency=inr&days=7",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChartData.fromJson(data);
      } else {
        print("Failed to load chart data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching chart data for $coinId: $e");
      return null;
    }
  }
}


