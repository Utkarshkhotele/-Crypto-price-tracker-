import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cryptotracker/models/API.dart';
import 'package:cryptotracker/models/Cryptocurrency.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<CryptoCurrency> markets = [];
  Timer? _timer;
  DateTime? lastUpdated;

  MarketProvider() {
    fetchData();

    // Auto update every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchData();
      print("⏱️ Data auto-updated");
    });
  }

  /// 🔧 Fixed return type from `void` to `Future<void>`
  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      List<dynamic> _markets = await API.getMarkets();
      List<CryptoCurrency> temp = [];

      for (var market in _markets) {
        CryptoCurrency newCrypto = CryptoCurrency.fromJSON(market);
        temp.add(newCrypto);
      }

      markets = temp;
      lastUpdated = DateTime.now();
    } catch (e) {
      print("❌ Error fetching data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  CryptoCurrency fetchCryptoById(String id) {
    return markets.firstWhere((element) => element.id == id);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}


