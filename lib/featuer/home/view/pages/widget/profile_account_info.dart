import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProfileAccountInfo extends StatelessWidget {
  final Data user;

  const ProfileAccountInfo({super.key, required this.user});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy • h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 12.h),
            child: Text(
              'Account Information',
              style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          _InfoRow(
            icon: Icons.fingerprint_rounded,
            title: 'Account ID',
            value: '#${user.id?.toString().padLeft(6, '0') ?? '000000'}',
            iconColor: AppColor.lightPurple,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.email_outlined,
            title: 'Email Address',
            value: user.email ?? 'N/A',
            iconColor: AppColor.mainBlue,
          ),
          const _Divider(),
          _InfoRow(
            icon: Icons.access_time_rounded,
            title: 'Last Activity',
            value: _formatDate(user.lastLogout),
            iconColor: AppColor.grey,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColor.secondaryWhite,
      height: 1,
      indent: 70.w,
      endIndent: 20.w,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.setipoppinssecondaryGery(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyle.setpoppinsBlack(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}