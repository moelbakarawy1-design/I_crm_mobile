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

  @override
  void initState() {
    super.initState();
  DeepLinkHandler.init(context);

    // Start fade-in animation
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // Check token and navigate after delay
    Timer(const Duration(seconds: 2), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    // Ensure LocalData is initialized
    // (In main.dart, you should already have: await LocalData.init();)
    final token = LocalData.accessToken;

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // ✅ User already logged in
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      // ❌ Not logged in yet
      Navigator.pushReplacementNamed(context, Routes.onBoardView);
    }
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
            ],
          ),
        ),
      ),
    );
  }
  @override
void dispose() {
  DeepLinkHandler.dispose();
  super.dispose();
}
}
