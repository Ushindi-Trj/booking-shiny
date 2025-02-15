import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

//  Form fields validation
class Validation {
  static String? validateTextField(String? name) {
    if (name == null || name.isEmpty) {
      return 'The card holder name is required!';
    }
    return null;
  }

  static String? validateCardNumber(String? number) {
    if (!isCardValidNumber(number!, checkLength: true)) {
      return 'Invalid card number';
    }
    return null;
  }

  static String? validateExpiryDate(String? expiryValue) {
    if (expiryValue == null || expiryValue.isEmpty) {
      return 'Invalid expiry date';
    } else if (expiryValue.length != 5) {
      return 'Invalid expiry date';
    }

    final expiryMonth = int.parse(expiryValue.substring(0, 2));
    final expiryYear = int.parse(expiryValue.substring(3, 5));
    final nowMonth = DateTime.now().month;
    final nowYear = DateTime.now().year % 100;

    if (expiryYear < nowYear ||
        (expiryYear == nowYear && expiryMonth < nowMonth)) {
      return 'Invalid expiry date';
    }
    return null;
  }

  static String? validateCvv(String? cvv) {
    if (cvv == null || cvv.isEmpty || cvv.length < 3) {
      return 'Invalid cvv';
    } else if (int.tryParse(cvv) == null) {
      return 'Invalid cvv';
    }
    return null;
  }
}