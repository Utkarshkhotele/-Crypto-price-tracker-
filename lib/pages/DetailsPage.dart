import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/models/chart_data.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:cryptotracker/utils/inr_formatter.dart';

class DetailsPage extends StatelessWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  Widget _infoTile(String title, String value,
      {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Crypto Details", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.5,
      ),
      body: Consumer<MarketProvider>(
        builder: (context, marketProvider, _) {
          final CryptoCurrency crypto = marketProvider.fetchCryptoById(id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Hero(
                      tag: crypto.id!,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(crypto.image!),
                        radius: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${crypto.name} (${crypto.symbol!.toUpperCase()})",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Current Price
                Text(
                  crypto.currentPrice!.inrFormat(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0395eb),
                  ),
                ),

                const SizedBox(height: 10),

                // Price Change
                Builder(builder: (context) {
                  final double priceChange = crypto.priceChange24!;
                  final double percentChange = crypto.priceChangePercentage24!;
                  final bool isNegative = priceChange < 0;

                  return Text(
                    "${isNegative ? '' : '+'}${percentChange.toStringAsFixed(2)}% "
                        "(${isNegative ? '' : '+'}${priceChange.toStringAsFixed(2)})",
                    style: TextStyle(
                      fontSize: 16,
                      color: isNegative ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Stats Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoTile("Market Cap", crypto.marketCap!.inrFormat()),
                            _infoTile("Market Rank", "#${crypto.marketCapRank}"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoTile("Low 24h", crypto.low24!.inrFormat()),
                            _infoTile("High 24h", crypto.high24!.inrFormat()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _infoTile("Circulating Supply", crypto.circulatingSupply!.toInt().toString()),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoTile("All Time Low", crypto.atl!.inrFormat()),
                            _infoTile("All Time High", crypto.ath!.inrFormat()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Chart Title
                const Text(
                  "7-Day Price History",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Chart Widget
                FutureBuilder<ChartData?>(
                  future: Provider.of<MarketProvider>(context, listen: false).fetchChartData(id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const Text("⚠️ Failed to load chart data.");
                    } else {
                      final prices = snapshot.data!.prices;

                      // Normalize timestamps to indexes for better x-axis scaling
                      final spots = List.generate(
                        prices.length,
                            (i) => FlSpot(i.toDouble(), prices[i][1]),
                      );

                      return SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                spots: spots,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.1),
                                ),
                                color: Colors.blueAccent,
                                barWidth: 3,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}













