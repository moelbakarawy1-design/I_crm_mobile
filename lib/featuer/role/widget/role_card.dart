import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/role/widget/role_details_sheet.dart';
import 'package:admin_app/featuer/role/widget/role_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:flutter_svg/flutter_svg.dart';


class RoleCard extends StatelessWidget {
  final RoleModel role;

  const RoleCard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showRoleDetailsSheet(context, role),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role.name,
                                    style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0XFF292D32))
),
                      if (role.permissions?.isNotEmpty ?? false)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            '${role.permissions!.length} permissions',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF9E9E9E)),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/svg/edit-2.svg'),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit role feature coming soon')),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF9E9E9E)),
                  onPressed: () => showRoleOptionsSheet(context, role),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
