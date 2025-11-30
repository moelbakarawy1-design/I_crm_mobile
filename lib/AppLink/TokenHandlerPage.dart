import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      // NOTE: Ensure this IP is accessible from your device/emulator
      final url = 'http://192.168.1.88:5000/api/auth/login/$token';
      
      final response = await Dio().post(
        url,
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Extract Access Token
        final jwt = data['token'] ?? '';
        final refreshToken = data['refreshToken'] ?? data['refresh_token'] ?? ''; 
        final user = data['user'] ?? {};
        final role = user['role']?['name'] ?? '';
        final userName = user['name'] ?? 'User';
        final userId = user['id']?.toString() ?? '';
        final userEmail = user['email'] ?? '';

        // -----------------------------------------------------------
        // ✅ EXTRACT PERMISSIONS (if available in this response)
        // -----------------------------------------------------------
        List<String> apiPermissions = [];
        if (user['role'] != null && user['role']['permissions'] != null) {
          apiPermissions = List<String>.from(user['role']['permissions']);
        }

        print("📥 Invite Login Success. Saving ${apiPermissions.length} permissions...");

        // Save both tokens securely
        await LocalData.saveTokens(
          accessToken: jwt,
          refreshToken: refreshToken.isNotEmpty ? refreshToken : null,
        );
        
        // Save User Data WITH Permissions
        await LocalData.saveUserData(
          userId: userId,
          userName: userName,
          userEmail: userEmail,
          userRole: role,
          permissions: apiPermissions, 
        );

        if (!mounted) return;
        setState(() => _message = "Welcome, $userName! Redirecting...");

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;

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