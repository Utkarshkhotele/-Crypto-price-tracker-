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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Market Cap Leaders',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // ✅ Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Cryptocurrency",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    Provider.of<MarketProvider>(context, listen: false).searchQuery = value;
                  },
                ),
              ),

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
                            contentPadding: const EdgeInsets.all(0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(currentCrypto.image!),
                            ),
                            title: Text(currentCrypto.name!),
                            subtitle: Text(currentCrypto.symbol!.toUpperCase()),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
