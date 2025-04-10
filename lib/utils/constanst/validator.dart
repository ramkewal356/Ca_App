import 'package:intl/intl.dart';

class ValidatorClass {
  static String? validatePassword(String password) {
    // Check if the password length is less than 8 characters
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check if the password contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check if the password contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check if the password contains at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check if the password contains at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    // If all checks pass, return null (no error)
    return null;
  }

  static String? validateEmail(String? email) {
    // Check if email is null or empty
    if (email == null || email.isEmpty) {
      return 'Enter your email';
    }

    // Regular expression to validate email format
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null; // Return null if the email is valid
  }

  static bool isValidMobile(String number) {
    final regex = RegExp(r'^(\+91[\s-]?)?[6-9]\d{9}$');
    return regex.hasMatch(number);
  }

  static bool isValidPanCard(String pan) {
    final RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    return panRegex.hasMatch(pan);
  }

  static bool isValidAadhaar(String aadhaar) {
    final RegExp aadhaarRegex = RegExp(r'^[2-9][0-9]{11}$');
    return aadhaarRegex.hasMatch(aadhaar);
  }
}

String formatValue(String? value) {
  return value != null ? value.toLowerCase().capitalize() : '';
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty
        ? this[0].toUpperCase() + substring(1).toLowerCase()
        : this;
  }
}

String dateFormate(int? date) {
  return DateFormat('dd/MM/yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(date ?? 0));
}
String timeFormate(int? date) {
  return DateFormat('h:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(date ?? 0));
}
