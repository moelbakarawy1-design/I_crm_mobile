import 'package:admin_app/config/router/routes.dart'; 
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart'; 
import 'package:admin_app/featuer/home/view/pages/settingPage/widgets/setting_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Define the specific blue color
  static const Color _changePasswordColor = Color(0xFF1A8EEA);
  static const Color _logoutColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainWhite, 
      appBar:CustomAppBar(title: 'settings',onMenuPressed: () => Navigator.pop(context),),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }
          if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }
          if (state is LogoutAllSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context, Routes.logInView, (route) => false,
            );
          }
          if (state is LogoutAllFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              buildSettingsButton(
                context: context,
                iconSvgPath: 'assets/svg/Lock.svg',
                text: 'Change Password',
                color: _changePasswordColor,
                onTap: () {
                  Navigator.pushNamed(context, Routes.changePasswordView);
                },
              ),
              SizedBox(height: 20.h),
               buildSettingsButton(
                context: context,
                iconSvgPath: 'assets/svg/profile.svg',
                text: 'Create Admin',
                color: _changePasswordColor,
                onTap: () {
                  Navigator.pushNamed(context, Routes.createAdminPage);
                },
              ),
              SizedBox(height: 20.h),

              // ✅ 2. Log Out From All Devices Button (Logic Added)
              buildSettingsButton(
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
               //  Log Out Button (Logic Uncommented)
             buildSettingsButton(
                   context: context,
                   iconSvgPath: 'assets/svg/Log Out.svg',
                   text: 'Log Out',
                   color: _logoutColor,
                   onTap: () async {
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

}