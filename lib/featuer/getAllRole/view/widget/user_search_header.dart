import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onChanged;

  const UserSearchHeader({
    super.key, 
    required this.searchController, 
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      color: AppColor.primaryWhite,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => onChanged(),
                style: AppTextStyle.setpoppinsBlack(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: 'Search by name or email...',
                  hintStyle: AppTextStyle.setipoppinssecondaryGery(fontSize: 12, fontWeight: FontWeight.w400),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColor.gray70, size: 20.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Refresh Button
          Container(
            height: 44.h,
            width: 44.h,
            decoration: BoxDecoration(
              color: AppColor.mainBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: AppColor.mainBlue),
              onPressed: () => context.read<GetAllUserCubit>().fetchAllUsers(),
            ),
          ),
        ],
      ),
    );
  }
}