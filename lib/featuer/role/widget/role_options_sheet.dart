import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/role/widget/delete_confirmation_dialog.dart';
import 'package:admin_app/featuer/role/widget/role_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showRoleOptionsSheet(BuildContext context, RoleModel role) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          ListTile(
            leading: const Icon(Icons.visibility, color: Color(0xFF0E87F8)),
            title: Text(
              'View Details',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              showRoleDetailsSheet(context, role);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Color(0xFF0E87F8)),
            title: Text(
              'Edit Role',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit role feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Delete Role',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showDeleteConfirmationDialog(context, role);
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    ),
  );
}
