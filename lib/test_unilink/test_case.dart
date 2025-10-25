import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:admin_app/config/router/routes.dart';

/// -------------------------------
/// 🔹 DeepLinkHandler
/// -------------------------------
class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;

  /// Initialize deep links
  static Future<void> init(BuildContext context) async {
    try {
      // لو التطبيق مفتوح لأول مرة من لينك
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleUri(context, initialLink);
      }

      // لو التطبيق شغال وجاه لينك جديد
      _sub = _appLinks.uriLinkStream.listen((uri) {
        _handleUri(context, uri);
      });
    } catch (e) {
      print('❌ Failed to init deep links: $e');
    }
  }

  /// Handle the incoming Uri
  static void _handleUri(BuildContext context, Uri uri) {
    print('🔗 Deep link opened: $uri');

    final token = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

    if (token == null) {
      print('⚠️ No token found in link');
      return;
    }

    print('✅ Extracted token: $token');

    // Navigate safely without stacking multiple pages
    if (Navigator.canPop(context)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TokenHandlerPage(token: token),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TokenHandlerPage(token: token),
        ),
      );
    }
  }

  /// Dispose the subscription
  static void dispose() {
    _sub?.cancel();
  }
}

/// -------------------------------
/// 🔹 TokenHandlerPage
/// -------------------------------
class TokenHandlerPage extends StatefulWidget {
  final String token;
  const TokenHandlerPage({super.key, required this.token});

  @override
  State<TokenHandlerPage> createState() => _TokenHandlerPageState();
}

class _TokenHandlerPageState extends State<TokenHandlerPage> {
  bool _loading = true;
  String _message = "Processing...";

  @override
  void initState() {
    super.initState();
    _sendTokenToServer();
  }

  Future<void> _sendTokenToServer() async {
    try {
      final response = await Dio().get(
        'http://192.168.1.88:5000/api/auth/login/${widget.token}',
      );

      print('✅ Server Response: ${response.data}');
      final role = response.data.toString().toLowerCase();

      setState(() {
        _message = "Token verified. Redirecting...";
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      switch (role) {
        case 'admin':
          Navigator.pushReplacementNamed(context, Routes.home);
          break;
        default:
          Navigator.pushReplacementNamed(context, Routes.logInView);
      }
    } catch (e) {
      print('❌ Error verifying token: $e');
      setState(() {
        _message = "Error verifying token.";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Verifying token..."),
                ],
              )
            : Text(_message),
      ),
    );
  }
}
