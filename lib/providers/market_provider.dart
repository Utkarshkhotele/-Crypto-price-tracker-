import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import '../models/Cryptocurrency.dart';
import '../models/api.dart';

class MarketProvider with ChangeNotifier {
  List<CryptoCurrency> _cryptos = [];
  bool _isLoading = false;
  String _searchQuery = "";
  bool _isINR = true;

  List<CryptoCurrency> get cryptos => _cryptos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get isINR => _isINR;

  void toggleCurrency() {
    _isINR = !_isINR;
    notifyListeners();
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<CryptoCurrency> get filteredMarkets {
    if (_searchQuery.isEmpty) return _cryptos;

    return _cryptos.where((crypto) {
      final name = (crypto.name ?? '').toLowerCase();
      final symbol = (crypto.symbol ?? '').toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          symbol.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<CryptoCurrency> get sortedMarkets {
    List<CryptoCurrency> copy = [...filteredMarkets];
    copy.sort((a, b) => a.marketCapRank!.compareTo(b.marketCapRank!));
    return copy;
  }

  Future<void> fetchMarkets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final markets = await API.getMarkets();
      _cryptos = markets.map((e) => CryptoCurrency.fromMap(e)).toList();
    } catch (e) {
      print(" Error fetching market data: $e");
      _cryptos = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshMarkets() async {
    await fetchMarkets();
  }

  CryptoCurrency fetchCryptoById(String id) {
    return _cryptos.firstWhere((coin) => coin.id == id);
  }

  Future<ChartData?> fetchChartData(String coinId) {
    return API.getChartData(coinId);
  }
}








