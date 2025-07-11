import 'package:flutter/material.dart';
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
      return 'Please enter email';
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

  static bool isValidICAI(String input) {
    final RegExp regex = RegExp(r'^(M|FM)?\d{6,7}$');
    return regex.hasMatch(input);
  }

  static bool isValidCARegNumber(String input) {
    final regex = RegExp(r'^[A-Z]{3}\d{7}$');
    return regex.hasMatch(input);
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

Future<String?> selectDateOfBirth(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now()
        .subtract(Duration(days: 365 * 18)), // default 18 years back
    firstDate: DateTime(1900), // earliest DOB
    lastDate: DateTime.now(), // cannot pick future date
  );

  if (pickedDate != null) {
    return DateFormat('dd/MM/yyyy').format(pickedDate);
    // _dobController.text = formattedDate;
  }
  return null;
}
bool isWithin15Minutes(String timeString) {
  try {
    final now = DateTime.now();

    // Parse '4:54 PM' as today's time
    final parsedTime = DateFormat('h:mm a').parse(timeString);

    // Combine with today's date
    final todayTime = DateTime(
        now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

    final diff = now.difference(todayTime).inMinutes;

    // Debug output
    debugPrint("⏱️ Parsed time: $todayTime, Now: $now, Difference: $diff min");

    return diff.abs() <= 15;
  } catch (e) {
    debugPrint("Failed to parse time: $e");
    return false;
  }
}
