import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderCard extends StatelessWidget {
  final Data user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.secondaryblue, AppColor.mainBlue],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAvatar(),
          SizedBox(height: 16.h),
          _buildName(),
          SizedBox(height: 6.h),
          _buildEmail(),
          SizedBox(height: 16.h),
          _buildRoleBadge(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.mainWhite.withOpacity(0.3), width: 2),
      ),
      child: CircleAvatar(
        radius: 45.r,
        backgroundColor: AppColor.mainWhite.withOpacity(0.2),
        child: Text(
          user.name?.substring(0, 1).toUpperCase() ?? '?',
          style: AppTextStyle.setpoppinsWhite(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      user.name ?? 'Unknown',
      style: AppTextStyle.setpoppinsWhite(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmail() {
    return Text(
      user.email ?? '',
      style: AppTextStyle.setpoppinsTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColor.mainWhite.withOpacity(0.8),
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.mainWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.mainWhite.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 16.sp, color: AppColor.mainWhite),
          SizedBox(width: 6.w),
          Text(
            user.role?.name?.toUpperCase() ?? 'USER',
            style: AppTextStyle.setpoppinsWhite(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}