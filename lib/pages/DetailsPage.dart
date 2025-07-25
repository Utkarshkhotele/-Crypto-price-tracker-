import 'package:flutter/material.dart';
import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:provider/provider.dart';
import 'package:cryptotracker/utils/inr_formatter.dart'; // <-- Add extension here

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget titleAndDetail(String title, String detail,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crypto Details"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<MarketProvider>(
            builder: (context, marketProvider, child) {
              CryptoCurrency crypto =
              marketProvider.fetchCryptoById(widget.id);

              return RefreshIndicator(
                onRefresh: () async {
                  await marketProvider.fetchData();
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(crypto.image!),
                          radius: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${crypto.name} (${crypto.symbol!.toUpperCase()})",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                crypto.currentPrice!.inrFormat(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0395eb),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Price Change (24h)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        double priceChange = crypto.priceChange24!;
                        double priceChangePercent =
                        crypto.priceChangePercentage24!;
                        final bool isNegative = priceChange < 0;

                        return Text(
                          "${isNegative ? '' : '+'}${priceChangePercent.toStringAsFixed(2)}% "
                              "(${isNegative ? '' : '+'}${priceChange.toStringAsFixed(4)})",
                          style: TextStyle(
                            fontSize: 20,
                            color: isNegative ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: titleAndDetail(
                            "Market Cap",
                            crypto.marketCap!.inrFormat(),
                          ),
                        ),
                        Expanded(
                          child: titleAndDetail(
                            "Market Rank",
                            "#${crypto.marketCapRank}",
                            align: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: titleAndDetail(
                            "Low 24h",
                            crypto.low24!.inrFormat(),
                          ),
                        ),
                        Expanded(
                          child: titleAndDetail(
                            "High 24h",
                            crypto.high24!.inrFormat(),
                            align: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    titleAndDetail(
                      "Circulating Supply",
                      crypto.circulatingSupply!.toInt().toString(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: titleAndDetail(
                            "All Time Low",
                            crypto.atl!.inrFormat(),
                          ),
                        ),
                        Expanded(
                          child: titleAndDetail(
                            "All Time High",
                            crypto.ath!.inrFormat(),
                            align: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

