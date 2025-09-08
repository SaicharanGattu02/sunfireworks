
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../utils/AppLogger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils/preferences.dart';



class AuthService {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _tokenExpiryKey = "token_expiry"; // epoch millis
  static const String _roleKey = "role";

  static final PreferenceService _prefs = PreferenceService();

  /// Check if the user is a guest (no token or empty token)
  static Future<bool> get isGuest async {
    final token = await getAccessToken();
    return token == null || token.isEmpty;
  }

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    return await _prefs.getString(_accessTokenKey);
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await _prefs.getString(_refreshTokenKey);
  }

  /// Get stored role
  static Future<String?> getRole() async {
    return await _prefs.getString(_roleKey);
  }

  /// Returns true if token has expired (or we can't determine expiry)
  static Future<bool> isTokenExpired() async {
    final expiryTimestamp = await _prefs.getInt(_tokenExpiryKey);
    if (expiryTimestamp == null) {
      AppLogger.log('No expiry timestamp found, considering token expired');
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final isExpired = now >= expiryTimestamp;

    AppLogger.log(
      'Token expiry check: now=$now, expiry=$expiryTimestamp, isExpired=$isExpired',
    );
    return isExpired;
  }

  static Future<void> saveTokens(
      String accessToken,
      String? refreshToken,
      String? role,
      int expiresIn,
      ) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    int expiryMs;
    if (expiresIn > 1000000000000) {
      // Looks like epoch in ms
      expiryMs = expiresIn;
    } else if (expiresIn > 1000000000) {
      // Looks like epoch in seconds
      expiryMs = expiresIn * 1000;
    } else {
      // Looks like duration in seconds
      expiryMs = nowMs + (expiresIn * 1000);
    }

     _prefs.saveString(_accessTokenKey, accessToken);
     _prefs.saveString(_refreshTokenKey, refreshToken ?? "");
     _prefs.saveString(_roleKey, role ?? "");
     _prefs.saveInt(_tokenExpiryKey, expiryMs);

    debugPrint(
      'Tokens saved: accessToken=<redacted>, refreshToken=${refreshToken != null ? "<redacted>" : "null"}, role=$role, expiryMs=$expiryMs',
    );
  }

  /// Logout and clear tokens, then redirect to sign-in/onboarding
  static Future<void> logout() async {
    // Clear only our relevant keys (safer than nuking *all* app preferences, but
    // if you truly want to wipe everything, call _prefs.clearPreferences()).
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_tokenExpiryKey);
    await _prefs.remove(_roleKey);

    debugPrint('Tokens cleared, user logged out');

    // Defer navigation slightly to ensure a valid context after frame
    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        final context = navigatorKey.currentContext;
        if (context != null) {
          debugPrint('Navigating to /onboarding');
          GoRouter.of(context).go('/onboarding');
        } else {
          debugPrint('Navigation context still null after delay');
        }
      });
    });
  }
}

