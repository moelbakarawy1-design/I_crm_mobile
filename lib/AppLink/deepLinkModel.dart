// ignore_for_file: empty_catches
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:admin_app/config/router/routes.dart';

// DeepLinkHandler
class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;
  static bool _initialized = false;

  /// Get initial link without handling it
  static Future<Uri?> getInitialLink() async {
    try {
      return await _appLinks.getInitialLink();
    } catch (e) {
      return null;
    }
  }
  // Initialize deep links
  static Future<void> init(BuildContext context) async {
    if (_initialized) {
      return;
    }   
    try {
      // Check if app opened initially by link
      final initialLink = await _appLinks.getInitialLink();
      
      if (initialLink != null) {
       
        // ignore: use_build_context_synchronously
        await _handleUri(context, initialLink);
      } else {
      }
    } catch (e) {
    }
  }

  // Handle the incoming URI and extract token
  static Future<void> _handleUri(BuildContext context, Uri uri) async {
    if (uri.pathSegments.isNotEmpty) {
    }

    String? tokenUrl;


    if (uri.scheme == 'mycrm' && uri.host == 'invite') {
      
      if (uri.pathSegments.isNotEmpty) {
        tokenUrl = uri.pathSegments.first;
      
      } else if (uri.path.isNotEmpty && uri.path != '/') {
        tokenUrl = uri.path.replaceFirst('/', '');
  
      } else {
      }
    } else {
    }

    if (tokenUrl == null || tokenUrl.isEmpty) {
   
      return;
    }
    if (!context.mounted) {
      return;
    }
    try {
     await Navigator.pushReplacementNamed(
      context,
     Routes.tokenHandlerPage,
     arguments: tokenUrl
);
    } catch (e) {
    }
  }

  static void dispose() {
    _sub?.cancel();
    _initialized = false;
  }
}

