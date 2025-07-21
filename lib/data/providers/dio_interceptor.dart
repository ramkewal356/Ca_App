import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DioInterceptor extends Interceptor {
  DioInterceptor();

  @override
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Clear token, logout user or show dialog
      await _handleTokenExpired();
      debugPrint('expire token ...........${err.response?.statusCode}');
    }
    return super.onError(err, handler);
  }

  Future<void> _handleTokenExpired() async {
    // Optional: Show dialog before navigating
    // await showDialog(...);

    // Clear user session or token
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login screen
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
