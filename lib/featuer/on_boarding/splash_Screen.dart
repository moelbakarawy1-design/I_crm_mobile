import 'dart:async';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/AppLink/test_case.dart'; // Make sure this path is correct
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
    
    // 1. Start the fade-in animation
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // 2. Start the combined navigation logic
    _startNavigation();
  }

  // ✅ --- NEW COMBINED NAVIGATION LOGIC ---
  Future<void> _startNavigation() async {
    // 1. Start both tasks at the same time
    final deepLinkFuture = _initializeDeepLinks();
    final timerFuture = Future.delayed(const Duration(seconds: 2));

    // 2. Wait for BOTH tasks to finish
    await Future.wait([deepLinkFuture, timerFuture]);

    // 3. By now, at least 2 seconds have passed AND our deep link
    //    check is complete. We can now safely check the flag.
    if (!_deepLinkHandled && mounted) {
      _checkLoginStatus();
    }
    // If _deepLinkHandled is true, we do nothing,
    // because _initializeDeepLinks() already handled the navigation.
  }

  Future<void> _initializeDeepLinks() async {
    try {
      print('🎯 SplashScreen: Initializing DeepLinkHandler...');
      
      // We assume DeepLinkHandler.init() also handles navigating
      // if an initial link is found.
      await DeepLinkHandler.init(context); 
      
      final initialLink = await DeepLinkHandler.getInitialLink();
      
      if (initialLink != null) {
        print('✅ Deep link detected, skipping normal navigation');
        // Set the flag so _startNavigation knows not to do anything
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
      
            ],
          ),
        ),
      ),
    );
  }
}