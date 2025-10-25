import 'package:admin_app/config/router/routes.dart';
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
          /// Background Image
          Image.asset(
            AppAssetsUtils.welcomeImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          /// Skip Button - Top Right
          Positioned(
            top: 40.h,
            right: 20.w,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.logInView);
              },
              icon: SvgPicture.asset(AppAssetsUtils.arrowForrwad,width: 24.w,height: 24.h,fit: BoxFit.scaleDown,),
              label: Text(
                'Skip',
                style: AppTextStyle.setpoppinsWhite(fontSize: 12, fontWeight: FontWeight.w500)
              ),
            ),
          ),
 Positioned(
  left: -30.w,
            right: 150.w,
            bottom: 100.h,
   child: Text(
                    'Welcome 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
 ),
  SizedBox(height: 20.h,),
          /// Welcome Text - Bottom
          Positioned(
            left: 10.w,
            right: 30.w,
            bottom: 40.h,
            child: Text(
              'Our CRM app helps you track leads, close deals, and build stronger relationships.Stay organized, save time, \nand grow your business all in one powerful dashboard.\n',
              textAlign: TextAlign.center,
              style: AppTextStyle.setpoppinsWhite(fontSize: 10, fontWeight: FontWeight.w500)
            ),
          ),
        ],
      ),
    );
  }
}
