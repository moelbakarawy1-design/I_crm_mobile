// ignore_for_file: deprecated_member_use

import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardView extends StatelessWidget {
  const OnBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssetsUtils.welcomeImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          /// Skip Button - Top Right (Original Position)
          Positioned(
            top: 40.h,
            right: 20.w,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.logInView);
              },
              icon: SvgPicture.asset(
                AppAssetsUtils.arrowForrwad,
                width: 24.w,
                height: 24.h,
                color: AppColor.lightBlue,
                fit: BoxFit.scaleDown,
              ),
              label: Text(
                'Skip',
                style: AppTextStyle.setpoppinsWhite(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          /// Content - Bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                  
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  /// Divider Line
                  Container(
                    width: 60.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  /// Description Text
                  Text(
                    'Our CRM app helps you track leads, close deals, and build stronger relationships.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.setpoppinsWhite(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ).copyWith(
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Stay organized, save time, and grow your business all in one powerful dashboard.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.setpoppinsWhite(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ).copyWith(
                      height: 1.6,
                      letterSpacing: 0.3,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  /// Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.logInView);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 8,
                      shadowColor: Colors.white.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, size: 20.sp),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}