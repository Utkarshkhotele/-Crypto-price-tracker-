import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<List<double>> prices;

  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(child: Text('⚠️ No chart data available.'));
    }

    // Normalize x-axis (index-based)
    final spots = prices.asMap().entries.map((entry) {
      final index = entry.key.toDouble(); // x-axis: 0,1,2,...
      final price = entry.value[1];       // y-axis: price
      return FlSpot(index, price);
    }).toList();

    final minY = prices.map((e) => e[1]).reduce((a, b) => a < b ? a : b);
    final maxY = prices.map((e) => e[1]).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📈 7-Day Price Chart", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.green,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  dotData: FlDotData(show: false),
                  barWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


