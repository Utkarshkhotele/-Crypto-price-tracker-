import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/pages/DetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ✅ Centered Title
              Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Market Movers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Cryptocurrency",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    Provider.of<MarketProvider>(context, listen: false).searchQuery = value;
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ✅ List of Cryptos
              Expanded(
                child: Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    if (marketProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final cryptos = marketProvider.filteredMarkets;

                      if (cryptos.isEmpty) {
                        return const Center(child: Text("No data found!"));
                      }

                      return ListView.builder(
                        itemCount: cryptos.length,
                        itemBuilder: (context, index) {
                          CryptoCurrency currentCrypto = cryptos[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(id: currentCrypto.id!),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(currentCrypto.image!),
                            ),
                            title: Text(
                              currentCrypto.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              currentCrypto.symbol!.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${currentCrypto.currentPrice!.toStringAsFixed(4)}",
                                  style: const TextStyle(
                                    color: Color(0xff0395ab),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    double priceChange = currentCrypto.priceChange24!;
                                    double priceChangePercentage = currentCrypto.priceChangePercentage24!;
                                    if (priceChange < 0) {
                                      return Text(
                                        "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                                        style: const TextStyle(color: Colors.red),
                                      );
                                    } else {
                                      return Text(
                                        "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                                        style: const TextStyle(color: Colors.green),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


