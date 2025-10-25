import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.gradientColors = const [Color(0xFF3B82F6), Color(0xFF93C5FD)], // Default blue gradient
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side (text)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Right side (icon with gradient background)
          Center(
            child: SvgPicture.asset(
              iconPath,
              width: 60.w,
              height: 60.h,
            
            ),
          ),
        ],
      ),
    );
  }
}
