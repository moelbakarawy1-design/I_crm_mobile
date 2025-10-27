import 'dart:async';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/test_unilink/test_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  bool _deepLinkHandled = false;

  @override
  void initState() {
    super.initState();
    
    // ✅ Initialize deep link handler AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🎯 SplashScreen: Initializing DeepLinkHandler...');
      _initializeDeepLinks();
    });

    // Start fade-in animation
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // Check token and navigate after delay (only if no deep link)
    Timer(const Duration(seconds: 2), () {
      if (!_deepLinkHandled && mounted) {
        _checkLoginStatus();
      }
    });
  }

  Future<void> _initializeDeepLinks() async {
    try {
      await DeepLinkHandler.init(context);
      
      // Check if a deep link was handled
      // If yes, the DeepLinkHandler will navigate to TokenHandlerPage
      // and we don't want to do the normal splash navigation
      final initialLink = await DeepLinkHandler.getInitialLink();
      if (initialLink != null) {
        print('✅ Deep link detected, skipping normal navigation');
        setState(() => _deepLinkHandled = true);
      }
    } catch (e) {
      print('❌ Error initializing deep links: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    if (!mounted) return;

    final token = LocalData.accessToken;

    if (token != null && token.isNotEmpty) {
      // ✅ User already logged in
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      // ❌ Not logged in yet
      Navigator.pushReplacementNamed(context, Routes.onBoardView);
    }
  }

  @override
  void dispose() {
    DeepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainWhite,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssetsUtils.mainLogo,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.h),
              // Optional: Show loading indicator
              if (!_deepLinkHandled)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}