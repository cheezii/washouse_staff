class PriceUtils {
  String convertFormatPrice(num price) {
    String priceString = price.toString();
    String priceConvert = '';
    int stringLength = priceString.length;

    String lastThreeChars = priceString.substring(stringLength - 3);
    if (stringLength <= 6) {
      priceConvert =
          '${priceString.substring(stringLength - stringLength, stringLength - 3)}.$lastThreeChars';
    } else if (stringLength > 6 && stringLength <= 9) {
      priceConvert =
          '${priceString.substring(stringLength - stringLength, stringLength - 6)}.${priceString.substring(stringLength - 6, stringLength - 3)}.$lastThreeChars';
    } else if (stringLength > 9) {
      '${priceString.substring(stringLength - stringLength, stringLength - 9)}.${priceString.substring(stringLength - 9, stringLength - 6)}.${priceString.substring(stringLength - 6, stringLength - 3)}.$lastThreeChars';
    }

    return priceConvert;
  }
}
