class PriceFormatter {
  static String format(dynamic price) {
    if (price == null) return '0.00';
    
    // Strip existing dollar signs, commas, or spaces
    String priceStr = price.toString().replaceAll(RegExp(r'[\$, ]'), '').trim();
    if (priceStr.isEmpty) return '0.00';
    
    final doubleValue = double.tryParse(priceStr);
    if (doubleValue == null) {
      return priceStr;
    }

    List<String> parts = priceStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Regular expression to add commas every three digits in integer part
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (Match match) => '${match[1]},');

    if (decimalPart.isNotEmpty) {
      if (decimalPart.length == 1) {
        decimalPart += '0';
      } else if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      return '$integerPart.$decimalPart';
    } else {
      return '$integerPart.00';
    }
  }

  static String formatWithCurrency(dynamic price, {String symbol = '\$'}) {
    final formatted = format(price);
    if (double.tryParse(formatted.replaceAll(',', '')) != null) {
      return '$symbol$formatted';
    }
    return formatted;
  }
}
