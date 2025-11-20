import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CusstomCard extends StatelessWidget {
  final String name;
  final String message;
  final String? time;
  final String? profilePicUrl;
  final int unreadCount;
  final String? messageStatus;
  final String? assignedTo;
  final String? messageType; // ✅ Added messageType to know what icon to show
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
    this.assignedTo,
    this.messageType, // ✅ Initialize
    this.onTap,
    this.onDelete,
  });

  String _formatTimestamp(String? isoString) {
    if (isoString == null) return "";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (date == today) return DateFormat.jm().format(dateTime);
      if (date == yesterday) return "Yesterday";
      return DateFormat('MM/dd/yyyy').format(dateTime);
    } catch (e) {
      return "";
    }
  }

  Widget _buildStatusIcon() {
    if (unreadCount > 0) return const SizedBox.shrink();

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

  // ✅ Logic to determine Icon and Text based on Type
  Widget _buildMessageContent(bool hasUnread) {
    IconData? icon;
    String text = message;
    Color textColor = hasUnread ? AppColor.lightBlue : Colors.grey.shade600;

    // Detect Type (safely handle nulls)
    String type = (messageType ?? '').toLowerCase();

    // Fallback detection from message text if type is missing
    if (type.isEmpty || type == 'text') {
       if (message.toLowerCase() == 'audio' || RegExp(r'^\d+$').hasMatch(message)) type = 'audio';
    }

    if (type == 'audio') {
      icon = Icons.mic;
      text = "Audio message";
    } else if (type == 'video') {
      icon = Icons.videocam;
      text = "Video";
    } else if (type == 'image') {
      icon = Icons.image;
      text = "Image"; // or "Photo"
    } else if (type == 'file' || type == 'document') {
      icon = Icons.insert_drive_file;
      text = "Document"; 
    } else if (type == 'location') {
      icon = Icons.location_on;
      text = "Location";
    } else if (type == 'contacts' || type == 'contact') {
      icon = Icons.person;
      text = "Contact";
    }

    // Render Icon + Text if it's media, otherwise just Text
    if (icon != null) {
      return Row(
        children: [
          Icon(icon, size: 16.sp, color: textColor),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 10.sp,
                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.setpoppinsTextStyle(
          fontSize: 10.sp,
          fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
          color: textColor,
        ),
      );
    }
  }

  Widget _buildUnreadBadge() {
    if (unreadCount <= 0) return const SizedBox.shrink();

    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(color: AppColor.lightBlue, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$unreadCount',
          style: AppTextStyle.setpoppinsWhite(fontSize: 10.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayTime = _formatTimestamp(time);
    final bool hasUnread = unreadCount > 0;
    final bool isAssigned = assignedTo != null && assignedTo != 'Unassigned';

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: CircleAvatar(
        radius: 25.r,
        backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
        backgroundColor: AppColor.lightBlue.withOpacity(0.3),
        child: profilePicUrl == null
            ? Icon(Icons.person, color: AppColor.mainWhite, size: 30.r)
            : null,
      ),
      title: Text(
        name,
        style: AppTextStyle.setpoppinsBlack(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          _buildStatusIcon(),
          Expanded(child: _buildMessageContent(hasUnread)), // ✅ Use new builder
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAssigned)
            Text(
              ' $assignedTo',
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.green,
              ),
            ),
          if (isAssigned) SizedBox(height: 5.h),
          Text(
            displayTime,
            style: AppTextStyle.setpoppinsTextStyle(
              fontSize: 11.sp,
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
              color: hasUnread ? AppColor.lightBlue : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 5.h),
          _buildUnreadBadge(),
        ],
      ),
      onTap: onTap,
      onLongPress: onDelete,
    );
  }
}