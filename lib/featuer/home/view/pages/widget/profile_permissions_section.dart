import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePermissionsSection extends StatelessWidget {
  final Data user;

  const ProfilePermissionsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainBlack.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 16.h),
          _buildPermissionChips(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.lightPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.admin_panel_settings_rounded,
            size: 18.sp,
            color: AppColor.lightPurple,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'Permissions',
          style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColor.mainBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '${user.role!.permissions!.length}',
            style: AppTextStyle.setpoppinsTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.mainBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: user.role!.permissions!.map((perm) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColor.secondaryWhite,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColor.lightGrey.withOpacity(0.3)),
          ),
          child: Text(
            perm.replaceAll('_', ' ').toUpperCase(),
            style: AppTextStyle.setpoppinsTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColor.grey,
            ),
          ),
        );
      }).toList(),
    );
  }
}