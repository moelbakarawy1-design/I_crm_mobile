import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;
  final List<Color> gradientColors;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.iconPath,
    this.gradientColors = const [Color(0xFF1366D9), Color(0xFF4C4DDC)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      height: 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainWhite,
            AppColor.primaryWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.secondaryWhite,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side (text)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyle.setipoppinssecondaryGery(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  value,
                  style: AppTextStyle.setpoppinsSecondaryBlack(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientColors.first.withOpacity(0.15),
                        gradientColors.last.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 14.sp,
                        color: gradientColors.first,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '+12.5%',
                        style: AppTextStyle.setpoppinsTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: gradientColors.first,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right side (icon with gradient background)
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientColors.first.withOpacity(0.15),
                  gradientColors.last.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 40.w,
                height: 40.h,
                colorFilter: ColorFilter.mode(
                  gradientColors.first,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}