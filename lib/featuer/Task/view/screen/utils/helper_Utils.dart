 import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:flutter/material.dart';

Widget buildUserChip(AssignedTo user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 8.0), // Adds space between users
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFD),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Icon
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColor.mainBlack,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          // Name and Email Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  user.email ?? 'No email',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTasksHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Start date & deadline', textAlign: TextAlign.start, style: headerStyle()),
          ),
          Expanded(
            flex: 4,
            child: Text('Task Title', textAlign: TextAlign.center, style: headerStyle()),
          ),
          Expanded(
            flex: 2,
            child: Text('Status', textAlign: TextAlign.center, style: headerStyle()),
          ),
          Expanded(
            flex: 1,
            child: Text('Edit', textAlign: TextAlign.right, style: headerStyle()),
          ),
        ],
      ),
    );
  }

  TextStyle headerStyle() {
    return AppTextStyle.setpoppinsTextStyle(
        fontSize: 10, fontWeight: FontWeight.w500, color: AppColor.secondaryGrey);
  }
  