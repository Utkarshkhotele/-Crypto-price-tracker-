import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/models/chart_data.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:cryptotracker/providers/favorites_provider.dart';
import 'package:cryptotracker/utils/inr_formatter.dart';

class DetailsPage extends StatelessWidget {
  final String id;
  const DetailsPage({super.key, required this.id});

  Widget _infoTile(String title, String value, BuildContext context,
      {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[400] : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Crypto Details",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer2<MarketProvider, FavoritesProvider>(
            builder: (context, marketProvider, favoritesProvider, _) {
              final CryptoCurrency coin = marketProvider.fetchCryptoById(id);
              final isFav = favoritesProvider.isFavorited(coin);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(coin);
                },
              );
            },
          ),
        ],
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
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(crypto.image!),
                        radius: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crypto.name ?? "",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color:
                              Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            "(${crypto.symbol!.toUpperCase()})",
                            style: TextStyle(
                              fontSize: 14,
                              color:
                              isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Current Price
                Text(
                  crypto.currentPrice!.inrFormat(),
                  style: const TextStyle(
                    fontSize: 30,
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

                // Stats
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isDark
                            ? Colors.grey[700]!
                            : Colors.grey.shade300),
                    boxShadow: isDark
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile("Market Cap",
                              crypto.marketCap!.inrFormat(), context),
                          _infoTile("Market Rank", "#${crypto.marketCapRank}",
                              context),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile(
                              "Low 24h", crypto.low24!.inrFormat(), context),
                          _infoTile(
                              "High 24h", crypto.high24!.inrFormat(), context),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _infoTile("Circulating Supply",
                          crypto.circulatingSupply!.toInt().toString(), context),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile(
                              "All Time Low", crypto.atl!.inrFormat(), context),
                          _infoTile(
                              "All Time High", crypto.ath!.inrFormat(), context),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "7-Day Price History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isDark
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: FutureBuilder<ChartData?>(
                    future:
                    Provider.of<MarketProvider>(context, listen: false)
                        .fetchChartData(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(" Failed to load chart data."),
                        );
                      } else {
                        final prices = snapshot.data!.prices;
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

















