extension InrFormatter on num {
  String inrFormat() {
    return "₹ ${toStringAsFixed(2)}";
  }
}
