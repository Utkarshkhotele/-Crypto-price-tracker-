import 'package:intl/intl.dart';

extension INRFormatter on double {
  String inrFormat() {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(this);
  }
}