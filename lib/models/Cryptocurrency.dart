class CryptoCurrency {
  final String? id;
  final String? name;
  final String? symbol;
  final String? image;

  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;

  final double? priceChange24;
  final double? priceChangePercentage24;

  final double? low24;
  final double? high24;
  final double? ath;
  final double? atl;

  final double? circulatingSupply;

  CryptoCurrency({
    this.id,
    this.name,
    this.symbol,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.priceChange24,
    this.priceChangePercentage24,
    this.low24,
    this.high24,
    this.ath,
    this.atl,
    this.circulatingSupply,
  });

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      id: map['id'],
      name: map['name'],
      symbol: map['symbol'],
      image: map['image'],
      currentPrice: (map['current_price'] as num?)?.toDouble(),
      marketCap: (map['market_cap'] as num?)?.toDouble(),
      marketCapRank: map['market_cap_rank'] as int?,
      priceChange24: (map['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24:
      (map['price_change_percentage_24h'] as num?)?.toDouble(),
      low24: (map['low_24h'] as num?)?.toDouble(),
      high24: (map['high_24h'] as num?)?.toDouble(),
      ath: (map['ath'] as num?)?.toDouble(),
      atl: (map['atl'] as num?)?.toDouble(),
      circulatingSupply: (map['circulating_supply'] as num?)?.toDouble(),
    );
  }
}
