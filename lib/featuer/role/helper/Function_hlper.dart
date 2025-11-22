 import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/role/widget/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildError(String message, BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.w, color: Colors.red),
              SizedBox(height: 24.h),
              Text('Error Loading Roles',
                  style: AppTextStyle.setpoppinsTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A))),
              SizedBox(height: 12.h),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.setpoppinsTextStyle(
                      fontSize: 14.sp, color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w500)),
              SizedBox(height: 32.h),
              CustomButton(
                onPressed: () {
                  context.read<InvitationCubit>().fetchRoles();
                },
                text: 'Retry',
                icon: const Icon(Icons.refresh, color: Colors.white),
                width: 150.w,
                height: 48.h,
              ),
            ],
          ),
        ),
      );

  Widget buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings_outlined,
                size: 100.w, color: const Color(0xFFE0E0E0)),
            SizedBox(height: 24.h),
            Text('No Roles Available',
                style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 16.sp, 
                    fontWeight: FontWeight.w600,
                    color: const Color(0XFF292D32))),
            SizedBox(height: 8.h),
            Text('Create a role to get started',
                style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 14.sp, color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget buildRoleList(List<RoleModel> roles) => Column(
        children: [
          Container(
            // ... (your existing code is fine) ...
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: roles.length,
              itemBuilder: (context, index) => RoleCard(role: roles[index]),
            ),
          ),
        ],
      );