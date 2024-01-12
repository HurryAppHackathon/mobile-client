import 'package:flutter/material.dart';

class Utils {
  BuildContext context;
  Utils(this.context);

  Size get screenSize => MediaQuery.of(context).size;
  String MathdorPrice(String price) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    String result = price.replaceAllMapped(reg, mathFunc);
    return result;
  }

  String numberToAlphanumeric(int number) {
    // Define a mapping of digits to letters
    final Map<String, String> digitToLetter = {
      '0': 'A',
      '1': 'B',
      '2': 'C',
      '3': 'D',
      '4': 'E',
      '5': 'F',
      '6': 'G',
      '7': 'H',
      '8': 'I',
      '9': 'J',
    };

    // Convert the number to a string
    final String numberStr = number.toString();

    // Convert each digit to the corresponding letter
    final alphanumericStr = numberStr.split('').map((digit) {
      return digitToLetter[digit] ?? digit;
    }).join('');

    return alphanumericStr;
  }
}

//class MyColors {
//  Color get color1 => const Color.fromARGB(255, 6, 147, 124);
//  Color get color2 => const Color.fromARGB(255, 7, 189, 168);
//  Color get color3 => const Color.fromARGB(255, 167, 255, 227);
//  Color get color4 => const Color.fromARGB(255, 216, 255, 243);
//  Color get color5 => const Color.fromARGB(255, 62, 160, 149);
//}
