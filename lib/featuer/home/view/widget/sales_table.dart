import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesTable extends StatelessWidget {
  final List<ChatPerUser> userData; 

  const SalesTable({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Container(
        width: 330.w,
        constraints: BoxConstraints(minHeight: 100.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTableHeader(),
            if (userData.isEmpty)
              Padding(
                padding: EdgeInsets.all(20.h),
                child: const Text("No user data available"),
              )
            else
              ...userData.map((user) => _buildTableRow(user)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Agent Name', 3),
          _buildHeaderCell('Total Chats', 2),
          // JSON only has chatsCount, hiding other columns or you can keep them 0
          _buildHeaderCell('ID (Partial)', 2), 
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyle.setpoppinsSecondaryBlack(
            fontSize: 10.sp, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(ChatPerUser user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(user.name ?? 'Unknown', 3, isName: true),
          _buildDataCell(user.chatsCount?.toString() ?? '0', 2, isBold: true),
          _buildDataCell(user.userId?.substring(0, 5) ?? '-', 2),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, int flex, {bool isName = false, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          color: isName ? Colors.blue[800] : Colors.grey[800],
          fontWeight: (isName || isBold) ? FontWeight.bold : FontWeight.normal,
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}