import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String selectedItem = 'Dashboard';

  Widget buildMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedItem == title;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          setState(() => selectedItem = title);
          onTap();
        },
        child: Container(
          width: 273.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.mainBlue : Colors.white,
            border: Border.all(
              color: isSelected ? AppColor.mainBlue : const Color(0xFFD7E2EE),
            ),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              SvgPicture.asset(
                iconPath,
                width: 22.w,
                height: 22.h,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : AppColor.mainBlue,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w400,  color: isSelected ? AppColor.primaryWhite : AppColor.mainBlue,)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.mainWhite,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Image.asset(
                AppAssetsUtils.mainLogo,
                width: 303.w,
                height: 258.h,
                fit: BoxFit.scaleDown,
              ),
            ),

            /// Menu Items
            buildMenuItem(
              title: 'Dashboard',
              iconPath: 'assets/svg/Home.svg',
              onTap: () {
                // Navigate to dashboard
              },
            ),
            buildMenuItem(
              title: 'WhatsApp',
              iconPath: 'assets/svg/watsapp.svg',
              onTap: () {},
            ),
            buildMenuItem(
              title: 'Customers',
              iconPath: 'assets/svg/profile.svg',
              onTap: () {},
            ),
            buildMenuItem(
              title: 'Access Control',
              iconPath: 'assets/svg/assescontrol.svg',
              onTap: () {
                Navigator.pushNamed(context, Routes.invitationPage);
              },
            ),
            buildMenuItem(
              title: 'Tasks',
              iconPath: 'assets/svg/task Store.svg',
              onTap: () {},
            ),
            buildMenuItem(
              title: 'Role',
              iconPath: 'assets/svg/briefcase.svg',
              onTap: () {
                Navigator.pushNamed(context, Routes.rolesPage);
              },
            ),

            const Spacer(),

            /// Logout button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content:
                          const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await AuthCubit.get(context).logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.logInView,
                        (route) => false,
                      );
                    }
                  }
                },
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD7E2EE)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      SvgPicture.asset(
                        'assets/svg/Log Out.svg',
                        width: 22.w,
                        height: 22.h,
                        colorFilter: const ColorFilter.mode(
                            Colors.red, BlendMode.srcIn),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
