// ignore_for_file: empty_catches
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart'; // Import LocalData
import 'package:shared_preferences/shared_preferences.dart';

class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;
  static bool _initialized = false;

  static Future<void> init(BuildContext context) async {
    if (_initialized) return;
    _initialized = true;

    try {
      final initialLink = await _appLinks.getInitialLink();

      if (initialLink != null) {
        // 1. Extract Token
        String? currentToken = _extractToken(initialLink);

        if (currentToken != null) {
          
          // 🛑 FIX 1: If user is ALREADY logged in, ignore invite links completely.
          // This prevents the app from re-processing the link after a restart.
          if (LocalData.accessToken != null && LocalData.accessToken!.isNotEmpty) {
            print("🛑 User already logged in. Ignoring Invite Link: $currentToken");
            return; 
          }

          final prefs = await SharedPreferences.getInstance();
          // Removed prefs.reload() as it can cause sync issues on some devices
          
          final lastToken = prefs.getString('last_handled_token');

          print("🔍 DeepLink Check:");
          print("   💾 Last Token:    '$lastToken'");
          print("   🔗 Current Token: '$currentToken'");

          // 2. Compare Tokens (Duplicate Check)
          if (lastToken == currentToken) {
            print("🚫 Stale Link Detected - Ignoring.");
            return;
          } 

          // 3. New Link: Save and Navigate
          print("✅ New Link Detected - Saving...");
          await prefs.setString('last_handled_token', currentToken);
          
          if (context.mounted) {
             _navigateToTokenPage(context, currentToken);
          }
        }
      }

      // Listen for NEW links (Stream)
      _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
           String? token = _extractToken(uri);
           if (token != null && context.mounted) {
             // For stream events, we usually allow them even if logged in
             // (e.g. user clicks a NEW invite link while using the app)
             _navigateToTokenPage(context, token);
           }
        }
      });

    } catch (e) {
      print("❌ DeepLink Init Error: $e");
    }
  }

  static String? _extractToken(Uri uri) {
    if (uri.scheme == 'mycrm' && uri.host == 'invite') {
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      } else if (uri.path.isNotEmpty && uri.path != '/') {
        return uri.path.replaceFirst('/', '');
      }
    }
    return null;
  }

  static void _navigateToTokenPage(BuildContext context, String token) {
    print("🚀 Navigating to TokenHandler...");
    Navigator.pushReplacementNamed(
      context,
      Routes.tokenHandlerPage,
      arguments: token,
    );
  }

  static void dispose() {
    _sub?.cancel();
    _initialized = false;
  }
}