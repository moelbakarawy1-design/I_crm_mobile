import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerMenu extends StatelessWidget {
  final Function(int)? onNavigate;
  final int currentIndex;

  const DrawerMenu({
    super.key,
    this.onNavigate,
    this.currentIndex = 0,
  });

  Widget buildMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50.h,
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
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? AppColor.primaryWhite : AppColor.mainBlue,
                  ),
                ),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Image.asset(
                AppAssetsUtils.mainLogo,
                width: 303.w,
                height: 258.h,
                fit: BoxFit.scaleDown,
              ),
            ),
            // Menu Items
            buildMenuItem(
              title: 'Dashboard',
              iconPath: 'assets/svg/Home.svg', // Assuming you have this or similar
              isSelected: currentIndex == 0,
              onTap: () {
                if (onNavigate != null) {
                  onNavigate!(0);
                  Navigator.pop(context); // Close drawer on mobile/tablet
                }
              },
            ),
            buildMenuItem(
              title: 'Profile',
              iconPath: 'assets/svg/profile.svg',
              isSelected: currentIndex == 1,
              onTap: () {
                Navigator.pushNamed(context, Routes.profilePage);
              },
            ),
            buildMenuItem(
              title: 'WhatsApp',
              iconPath: 'assets/svg/watsapp.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.chatScreen);
              },
            ),
            buildMenuItem(
              title: 'Users',
              iconPath: 'assets/svg/profile.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.allUsersScreen);
              },
            ),
            buildMenuItem(
              title: 'Access Control',
              iconPath: 'assets/svg/assescontrol.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.invitationPage);
              },
            ),
            buildMenuItem(
              title: 'Tasks',
              iconPath: 'assets/svg/task Store.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.tasksScreen);
              },
            ),
            buildMenuItem(
              title: 'Role',
              iconPath: 'assets/svg/briefcase.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.rolesPage);
              },
            ),
            const SizedBox(height: 20),
            // Settings at bottom
            buildMenuItem(
              title: 'Setting',
              iconPath: 'assets/svg/setting-2.svg',
              isSelected: false,
              onTap: () {
                Navigator.pushNamed(context, Routes.settingsPage);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
