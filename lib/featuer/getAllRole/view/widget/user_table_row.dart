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
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(4),
          3: FlexColumnWidth(4),
          4: FlexColumnWidth(5),
        },
        children: [
          TableRow(
            children: [
              _tableCell(user.name ?? ''),
              _tableCell(user.email ?? ''),
              _tableCell(user.role?.name ?? '—'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      child: SvgPicture.asset('assets/svg/Component _edit.svg',
                          width: 30, height: 30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditUserScreen(user: user)),
                        );
                      },
                    ),
                    SizedBox(width: 4.w),
                    InkWell(
                      child: SvgPicture.asset('assets/svg/Component _delete.svg',
                          width: 30, height: 30),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete User"),
                              content: Text("Are you sure you want to delete ${user.name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<GetAllUserCubit>().deleteUser(user.id!);
                                  },
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Text(
        text,
        style: AppTextStyle.setpoppinsTextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF7E92A2)),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}