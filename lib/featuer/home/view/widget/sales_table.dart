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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.mainWhite,
              AppColor.primaryWhite,
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.secondaryWhite,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.mainBlue.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildTableHeader(),
            if (userData.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 48.sp,
                      color: AppColor.secondaryGrey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "No user data available",
                      style: AppTextStyle.setipoppinssecondaryGery(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...userData.asMap().entries.map((entry) {
                int index = entry.key;
                ChatPerUser user = entry.value;
                return _buildTableRow(user, index);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
       color: AppColor.lightPurple.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Agent Name', 3),
          _buildHeaderCell('Total Chats', 2),
          _buildHeaderCell('User ID', 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyle.setpoppinsTextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.mainBlue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow(ChatPerUser user, int index) {
    final isEven = index % 2 == 0;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isEven ? Colors.transparent : AppColor.primaryWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColor.secondaryWhite,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(user.name ?? 'Unknown', 3, isName: true),
          _buildDataCell(user.chatsCount?.toString() ?? '0', 2, isBold: true),
          _buildDataCell(user.userId?.substring(0, 8) ?? '-', 2),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, int flex,
      {bool isName = false, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isName)
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.mainBlue,
                      AppColor.lightPurple,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            Flexible(
              child: Text(
                text,
                style: isName
                    ? AppTextStyle.setpoppinsTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.mainBlue,
                      )
                    : isBold
                        ? AppTextStyle.setpoppinsSecondaryBlack(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          )
                        : AppTextStyle.setipoppinssecondaryGery(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}