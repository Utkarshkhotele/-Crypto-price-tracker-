import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/pages/DetailsPage.dart';
import 'package:cryptotracker/pages/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          'Market Movers',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: ThemeSwitcher(),
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // 🔍 Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "Search Cryptocurrency",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    Provider.of<MarketProvider>(context, listen: false).searchQuery = value;
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 📃 Crypto List
              Expanded(
                child: Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    if (marketProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

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
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            currentCrypto.symbol!.toUpperCase(),
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
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

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: isDark ? Colors.yellow[600] : Colors.black87,
      ),
      onPressed: () {
        themeProvider.toggleTheme(!isDark);
      },
    );
  }
}

