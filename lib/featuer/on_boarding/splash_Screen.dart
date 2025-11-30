import 'dart:async';
import 'package:admin_app/AppLink/deepLinkModel.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  Offset _offset = const Offset(0, 0.5);
  
  // ❌ REMOVED: _deepLinkHandled flag (This was causing the bug)

  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _offset = Offset.zero;
          _opacity = 1.0;
        });
      }
    });

    _startNavigation();
  }

  Future<void> _startNavigation() async {
    final deepLinkFuture = _initializeDeepLinks();
    final timerFuture = Future.delayed(const Duration(seconds: 2));

    await Future.wait([deepLinkFuture, timerFuture]);

    // ✅ CHECK MOUNTED
    // If DeepLinkHandler processed a valid NEW link, it would have navigated away 
    // (unmounting this screen). So 'mounted' would be false.
    // If it was a STALE link (ignored), we are still mounted, so we proceed to login check.
    if (mounted) {
      _checkLoginStatus();
    }
  }

  Future<void> _initializeDeepLinks() async {
    try {
      print('🎯 SplashScreen: Initializing DeepLinkHandler...');
      
      // ✅ Let DeepLinkHandler do the work (Stale check + Navigation)
      await DeepLinkHandler.init(context); 
      
      // ❌ REMOVED: The manual getInitialLink() check.
      // Do not manually check the link here; the Handler will do it intelligently.
    } catch (e) {
      print('❌ Error initializing deep links: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    if (!mounted) return;

    final token = LocalData.accessToken; 
    final userRole = await LocalData.getUserRole(); 

    if (token != null && token.isNotEmpty) {
      print("User is logged in. Role: $userRole");

      if (userRole == 'admin' || userRole == 'MANAGER') {
        Navigator.pushReplacementNamed(context, Routes.home); 
      } else if (userRole == 'sales') {
        // Ensure this route exists in your Router
        Navigator.pushReplacementNamed(context, Routes.salsedashboard); 
      } else {
        print("Unknown role, navigating to home.");
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } else {
      print("User is not logged in, navigating to onBoardView.");
      Navigator.pushReplacementNamed(context, Routes.onBoardView);
    }
  }

  @override
  void dispose() {
     DeepLinkHandler.dispose(); // Best to keep it alive for app lifetime
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
          child: AnimatedSlide(
            offset: _offset,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutCubic,
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
      ),
    ); 
  }
}