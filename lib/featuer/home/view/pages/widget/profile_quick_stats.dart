import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProfileQuickStats extends StatelessWidget {
  final Data user;

  const ProfileQuickStats({super.key, required this.user});

  String _getShortDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.security_rounded,
            value: '${user.role?.permissions?.length ?? 0}',
            label: 'Permissions',
            color: AppColor.lightPurple,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatItem(
            icon: Icons.calendar_month_rounded,
            value: _getShortDate(user.createdAt),
            label: 'Joined',
            color: AppColor.mainBlue,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainBlack.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  label,
                  style: AppTextStyle.setipoppinssecondaryGery(fontSize: 11, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}