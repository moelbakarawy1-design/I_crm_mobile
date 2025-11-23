import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/getAllRole/view/screens/EditUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserCardItem extends StatelessWidget {
  final Data user;

  const UserCardItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Generate initials safely
    final String initials = (user.name != null && user.name!.isNotEmpty)
        ? user.name!.substring(0, 1).toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: AppColor.secondaryWhite),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColor.mainBlue.withOpacity(0.1),
              child: Text(
                initials,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600, 
                  color: AppColor.mainBlue
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Unknown',
                    style: AppTextStyle.setpoppinsBlack(fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.email ?? 'No Email',
                    style: AppTextStyle.setipoppinssecondaryGery(fontSize: 11, fontWeight: FontWeight.w400),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Role Chip
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role?.name ?? 'No Role',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.w500, 
                        color: AppColor.gray70
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Actions Column
            Column(
              children: [
                _actionButton(
                  context,
                  icon: 'assets/svg/Component _edit.svg',
                  color: AppColor.mainBlue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditUserScreen(user: user)),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                _actionButton(
                  context,
                  icon: 'assets/svg/Component _delete.svg',
                  color: Colors.redAccent,
                  onTap: () => _showDeleteDialog(context, user),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required String icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: SvgPicture.asset(
          icon,
          width: 20.w,
          height: 20.w,
        ),
      ),
    );
  }

  // 🗑 Delete Dialog
  void _showDeleteDialog(BuildContext context, Data user) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text("Delete User", style: AppTextStyle.setpoppinsBlack(fontSize: 16, fontWeight: FontWeight.w600)),
          content: Text(
            "Are you sure you want to remove ${user.name}?\nThis action cannot be undone.",
            style: AppTextStyle.setipoppinssecondaryGery(fontSize: 13, fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel", style: AppTextStyle.setipoppinssecondaryGery(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<GetAllUserCubit>().deleteUser(user.id!);
              },
              child: Text("Delete", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }
}