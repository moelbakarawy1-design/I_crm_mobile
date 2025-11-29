 import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget buildSettingsButton({
    required BuildContext context,
    IconData? icon,
    String? iconSvgPath,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    Widget iconWidget;
    if (iconSvgPath != null) {
      iconWidget = SvgPicture.asset(
        iconSvgPath,
        width: 22.w,
        height: 22.h,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else if (icon != null) {
      iconWidget = Icon(
        icon,
        color: color,
        size: 24.sp,
      );
    } else {
      iconWidget = SizedBox(width: 24.w);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            iconWidget,
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
