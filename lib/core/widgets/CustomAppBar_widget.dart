import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Title is now first (Left Side)
              Text(
                title,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.mainBlue,
                ),
              ),

              // 2. Menu Icon is now second (Right Side)
              IconButton(
                icon: const Icon(Icons.menu, color: AppColor.grey),
                onPressed: onMenuPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}