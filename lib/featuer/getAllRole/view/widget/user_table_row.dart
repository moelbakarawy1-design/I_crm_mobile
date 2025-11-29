import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/getAllRole/view/screens/EditUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableRowWidget extends StatelessWidget {
  final Data user;

  const TableRowWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Name Column
            Expanded(
              flex: 4,
              child: _tableCell(user.name ?? ''),
            ),
            // Email Column
            Expanded(
              flex: 4,
              child: _tableCell(user.email ?? ''),
            ),
            // Role Column
            Expanded(
              flex: 3,
              child: _tableCell(user.role?.name ?? '—'),
            ),
            // Actions Column
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Button
                    Flexible(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.r),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditUserScreen(user: user)),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/svg/Component _edit.svg',
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    // Delete Button
                    Flexible(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.r),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete User"),
                                content: Text(
                                    "Are you sure you want to delete ${user.name}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context
                                          .read<GetAllUserCubit>()
                                          .deleteUser(user.id!);
                                    },
                                    child: const Text("Delete",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/svg/Component _delete.svg',
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Text(
        text,
        style: AppTextStyle.setpoppinsTextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color:  AppColor.secondaryGrey,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}