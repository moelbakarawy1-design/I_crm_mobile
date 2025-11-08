import 'package:admin_app/config/router/routes.dart'; // Make sure Routes is imported
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart'; // Assuming you use this
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart'; // Import Auth States
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart'; // Import AuthCubit
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture if not already

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Define the specific blue color
  static const Color _changePasswordColor = Color(0xFF1A8EEA);
  static const Color _logoutColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainWhite, // Light background color
      appBar: AppBar(
        backgroundColor: AppColor.secondaryWhite,
        elevation: 1,
        centerTitle: false, // Title aligned left
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.blue, // Keep AppBar title blue for consistency
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // ✅ 1. Added BlocListener to handle navigation and errors
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // --- Handle Regular Logout ---
          if (state is LogoutSuccess) {
            // On success, navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }
          if (state is LogoutFailure) {
            // On failure, show error (but still log out)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }

          // --- Handle Logout All ---
          if (state is LogoutAllSuccess) {
            // On success, navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }
          if (state is LogoutAllFailure) {
            // On failure, just show the error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              // 1. Change Password Button (No change)
              _buildSettingsButton(
                context: context,
                iconSvgPath: 'assets/svg/Lock.svg', // Use your Lock SVG
                text: 'Change Password',
                color: _changePasswordColor,
                onTap: () {
                  Navigator.pushNamed(context, Routes.changePasswordView);
                },
              ),
              SizedBox(height: 20.h),

              // ✅ 2. Log Out From All Devices Button (Logic Added)
              _buildSettingsButton(
                context: context,
                iconSvgPath: 'assets/svg/Log Out.svg',
                text: 'Log Out From All Devices',
                color: _logoutColor,
                onTap: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout All'),
                      content: const Text(
                          'Are you sure you want to log out from all devices?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Log Out All',
                            style: TextStyle(color: _logoutColor),
                          ),
                        ),
                      ],
                    ),
                  );

                  // If user confirmed, call the cubit method
                  if (shouldLogout == true && context.mounted) {
                    context.read<AuthCubit>().logoutAllDevices();
                  }
                },
              ),
              SizedBox(height: 20.h),

              // ✅ 3. Log Out Button (Logic Uncommented)
             _buildSettingsButton(
  context: context,
  iconSvgPath: 'assets/svg/Log Out.svg',
  text: 'Log Out',
  color: _logoutColor,
  onTap: () async {
    // Show confirmation dialog (this is perfect)
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: _logoutColor),
            ),
          ),
        ],
      ),
    );
if (shouldLogout == true && context.mounted) {
      context.read<AuthCubit>().logout(); 
      Navigator.pushNamed(context, Routes.logInView);
    }
  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- This helper widget is perfect, no changes needed ---
  Widget _buildSettingsButton({
    required BuildContext context,
    IconData? icon,
    String? iconSvgPath,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    Widget iconWidget;
    if (iconSvgPath != null) {
      iconWidget = SvgPicture.asset(
        iconSvgPath,
        width: 22.w,
        height: 22.h,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else if (icon != null) {
      iconWidget = Icon(
        icon,
        color: color,
        size: 24.sp,
      );
    } else {
      iconWidget = SizedBox(width: 24.w);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            iconWidget,
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}