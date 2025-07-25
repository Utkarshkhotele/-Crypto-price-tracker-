import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import '../models/Cryptocurrency.dart';
import '../models/api.dart';

class MarketProvider with ChangeNotifier {
  List<CryptoCurrency> _cryptos = [];
  bool _isLoading = false;
  String _searchQuery = "";

  List<CryptoCurrency> get cryptos => _cryptos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners(); // trigger rebuild of UI
  }

  List<CryptoCurrency> get filteredMarkets {
    if (_searchQuery.isEmpty) return _cryptos;
    return _cryptos
        .where((crypto) =>
    crypto.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        crypto.symbol!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchMarkets() async {
    _isLoading = true;
    notifyListeners();

    final markets = await API.getMarkets();
    _cryptos = markets.map((e) => CryptoCurrency.fromMap(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  CryptoCurrency fetchCryptoById(String id) {
    return _cryptos.firstWhere((coin) => coin.id == id);
  }

  Future<ChartData?> fetchChartData(String coinId) {
    return API.getChartData(coinId);
  }
}




