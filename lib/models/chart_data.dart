class ChartData {
  final List<List<double>> prices;

  ChartData({required this.prices});

  /// Factory to create ChartData from JSON response from CoinGecko
  factory ChartData.fromJson(Map<String, dynamic> json) {
    try {
      final rawPrices = json['prices'] as List<dynamic>;

      final parsedPrices = rawPrices.map<List<double>>((entry) {
        // Ensure each entry is a List with two numeric values
        if (entry is List && entry.length == 2) {
          double timestamp = (entry[0] as num).toDouble();
          double price = (entry[1] as num).toDouble();
          return [timestamp, price];
        } else {
          throw FormatException("Invalid price entry format");
        }
      }).toList();

      return ChartData(prices: parsedPrices);
    } catch (e) {
      print("❌ ChartData parsing failed: $e");
      return ChartData(prices: []);
    }
  }
}







