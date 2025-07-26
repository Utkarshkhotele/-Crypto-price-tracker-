import 'package:flutter/material.dart';
import '../models/Cryptocurrency.dart';

class FavoritesProvider with ChangeNotifier {
  final List<CryptoCurrency> _favorites = [];

  List<CryptoCurrency> get favorites => _favorites;

  bool isFavorited(CryptoCurrency coin) {
    return _favorites.any((c) => c.id == coin.id);
  }

  void toggleFavorite(CryptoCurrency coin) {
    isFavorited(coin)
        ? _favorites.removeWhere((c) => c.id == coin.id)
        : _favorites.add(coin);
    notifyListeners();
  }

  void removeFavorite(CryptoCurrency coin) {
    _favorites.removeWhere((c) => c.id == coin.id);
    notifyListeners();
  }
}
