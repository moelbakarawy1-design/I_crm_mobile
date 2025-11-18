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
  Offset _offset = const Offset(0, 0.5);
  bool _deepLinkHandled = false;

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

    if (!_deepLinkHandled && mounted) {
      _checkLoginStatus();
    }
 
  }

  Future<void> _initializeDeepLinks() async {
    try {
      print('🎯 SplashScreen: Initializing DeepLinkHandler...');
      
  
      await DeepLinkHandler.init(context); 
      
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
  
  final userRole = await LocalData.getUserRole(); 

  if (token != null && token.isNotEmpty) {
    
    print("User is logged in. Role: $userRole");

    if (userRole == 'admin') {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.home); 
      
    } else if (userRole == 'sales') {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.salsedashboard); 

    } else {
  
      print("Unknown role, navigating to home.");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.home);
    }
    
  } else {
    print("User is not logged in, navigating to onBoardView.");
    // ignore: use_build_context_synchronously
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
          // 3. WRAP your Column with AnimatedSlide
          child: AnimatedSlide(
            offset: _offset,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutCubic, // A nice curve for motion
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