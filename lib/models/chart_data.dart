class ChartData {
  final List<List<double>> prices;

  ChartData({required this.prices});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    try {
      final rawPrices = json['prices'] as List<dynamic>;

      final parsedPrices = rawPrices.map<List<double>>((entry) {
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
      print(" ChartData parsing failed: $e");
      return ChartData(prices: []);
    }
  }
}







