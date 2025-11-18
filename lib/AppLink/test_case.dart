import 'dart:async';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
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

  /// Handle the incoming URI and extract token
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

    // ignore: empty_catches
    } catch (e) {
    }
  }

  static void dispose() {
    _sub?.cancel();
    _initialized = false;
  }
}


// 🔹 TokenHandlerPage

class TokenHandlerPage extends StatefulWidget {
  final String token;
  const TokenHandlerPage({super.key, required this.token});

  @override
  State<TokenHandlerPage> createState() => _TokenHandlerPageState();
}

class _TokenHandlerPageState extends State<TokenHandlerPage> {
  bool _loading = true;
  String _message = "Verifying your invite...";

  @override
  void initState() {
    super.initState();
    if (widget.token.isEmpty) {
      setState(() {
        _message = "Invalid invite link - no token provided";
        _loading = false;
      });
    } else {
      _verifyToken(widget.token);
    }
  }

  Future<void> _verifyToken(String token) async {
    try {
      final url = 'http://192.168.1.88:5000/api/auth/login/$token';
      final response = await Dio().get(
        url,
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final jwt = data['token'] ?? '';
        final user = data['user'] ?? {};
        final role = user['role']?['name'] ?? '';
        final userName = user['name'] ?? 'User';
        final userId = user['id']?.toString() ?? '';
        final userEmail = user['email'] ?? '';

        // Save securely
        await LocalData.saveTokens(accessToken: jwt);
        await LocalData.saveUserData(
          userId: userId,
          userName: userName,
          userEmail: userEmail,
          userRole: role,
        );

        if (!mounted) return;
        setState(() => _message = "Welcome, $userName! Redirecting...");

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;

        // Navigate based on role
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        if (!mounted) return;
        setState(() {
          _message = "Invalid or expired invite link.";
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = "Error verifying invite. Please try again.";
        _loading = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pushReplacementNamed(context, Routes.logInView);
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
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    _message,
                    style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _message,
                      style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}