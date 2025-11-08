import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CusstomCard extends StatelessWidget {
  final String name;
  final String message;
  final String? time; 
  final String? profilePicUrl;
  final int unreadCount;
  final String? messageStatus; 
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CusstomCard({
    super.key,
    required this.name,
    required this.message,
    this.time,
    this.profilePicUrl,
    this.unreadCount = 0,
    this.messageStatus,
    this.onTap,
    this.onDelete,
  });

  /// Helper to format timestamp like WhatsApp
  String _formatTimestamp(String? isoString) {
    if (isoString == null) return "";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (date == today) {
        return DateFormat.jm().format(dateTime); 
      } else if (date == yesterday) {
        return "Yesterday";
      } else {
        return DateFormat('MM/dd/yyyy').format(dateTime); 
      }
    } catch (e) {
      return ""; 
    }
  }

  Widget _buildStatusIcon(BuildContext context) {
    if (unreadCount > 0) {
      return const SizedBox.shrink();
    }

    IconData iconData = Icons.done; 
    Color iconColor = Colors.grey.shade600;

    if (messageStatus == 'delivered') {
      iconData = Icons.done_all;
    } else if (messageStatus == 'read') {
      iconData = Icons.done_all;
      iconColor = AppColor.lightBlue; 
    }

    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Icon(iconData, size: 18.sp, color: iconColor),
    );
  }

  Widget _buildUnreadBadge(BuildContext context) {
    if (unreadCount <= 0) {
      return SizedBox(height: 20.r);
    }

    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        color: AppColor.lightBlue, 
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$unreadCount',
          style: AppTextStyle.setpoppinsWhite(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayTime = _formatTimestamp(time);
    final bool hasUnread = unreadCount > 0;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: CircleAvatar(
        radius: 25.r,
        backgroundImage:
            profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
        backgroundColor: AppColor.lightBlue.withOpacity(0.3),
        child: profilePicUrl == null
            ? Icon(Icons.person, color: AppColor.mainWhite, size: 30.r)
            : null,
      ),
      title: Text(
        name,
        style: AppTextStyle.setpoppinsBlack(
          fontSize: 12.sp, 
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Row(
        children: [
          _buildStatusIcon(context),
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 10.sp, 
                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                
                color: hasUnread
                    ? AppColor.lightBlue
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            displayTime,
            style: AppTextStyle.setpoppinsTextStyle(
              fontSize: 11.sp,
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
              color: hasUnread ? AppColor.lightBlue : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 5.h),
          _buildUnreadBadge(context),
        ],
      ),
      onTap: onTap,
      onLongPress: onDelete, 
    );
  }
}