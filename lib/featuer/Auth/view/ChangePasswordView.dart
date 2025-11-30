import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      final request = ChangePasswordRequest(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirm: _confirmPasswordController.text,
      );
      context.read<AuthCubit>().changePassword(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Wrap with FutureBuilder to check Role first
    return FutureBuilder<String?>(
      future: LocalData.getUserRole(),
      builder: (context, snapshot) {       
        // 2. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1E90FF),
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        // 3. Permission Logic
        final String? userRole = snapshot.data;
        final bool isAllowed = userRole != null && 
            (userRole.toLowerCase() == 'admin' || userRole.toLowerCase() == 'manager');

        // 4. Access Denied State
        if (!isAllowed) {
          return Scaffold(
            backgroundColor: AppColor.mainWhite,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_person_outlined, size: 64.sp, color: AppColor.lightBlue),
                  SizedBox(height: 16.h),
                  Text(
                    "Restricted Access",
                    style: TextStyle(
                      fontSize: 20.sp, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Only Admins and Managers can change passwords here.",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        // 5. Success State: Render the Original Form
        return Scaffold(
          backgroundColor: const Color(0xFF1E90FF),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 4, 
                  child: Center(
                    child: SvgPicture.asset('assets/svg/reset_Password.svg')
                  ),
                ),
                Expanded(
                  flex: 10, 
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.mainWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.r),
                        topRight: Radius.circular(50.r),
                      ),
                    ),
                    child: BlocListener<AuthCubit, AuthState>( 
                      listener: (context, state) {
                        if (state is ChangePasswordSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password changed! Please log in again.'),
                                backgroundColor: Colors.green),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.logInView, 
                            (route) => false,
                          );
                        }
                        if (state is ChangePasswordFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(state.errorMessage),
                                backgroundColor: Colors.red),
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 40.h,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Change Password',
                                style: AppTextStyle.setpoppinsBlack(
                                    fontSize: 32, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Enter your old and new password below',
                                style: AppTextStyle.setpoppinsBlack(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 32.h),

                              // --- Old Password Field ---
                              Text('Old Password', style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)),
                              SizedBox(height: 8.h),
                              CustomTextFormField(
                                controller: _oldPasswordController,
                                hintText: 'Enter old password',
                                obscureText: _obscureOldPassword,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                                  icon: _obscureOldPassword
                                      ? SvgPicture.asset('assets/svg/eye-slash.svg', width: 24.w, height: 24.h)
                                      : SvgPicture.asset('assets/svg/eye_open.svg', width: 24.w, height: 24.h),
                                ),
                                validator: FieldValidator.password,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 20.h),

                              //New Password Field
                              Text('New Password', style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)),
                              SizedBox(height: 8.h),
                              CustomTextFormField(
                                controller: _newPasswordController,
                                hintText: 'Enter new password',
                                obscureText: _obscureNewPassword,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                                  icon: _obscureNewPassword
                                      ? SvgPicture.asset('assets/svg/eye-slash.svg', width: 24.w, height: 24.h)
                                      : SvgPicture.asset('assets/svg/eye_open.svg', width: 24.w, height: 24.h),
                                ),
                                validator: FieldValidator.password,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 20.h),

                              //Confirm Password Field
                              Text('Confirm Password', style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)),
                              SizedBox(height: 8.h),
                              CustomTextFormField(
                                controller: _confirmPasswordController,
                                hintText: 'Confirm new password',
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  icon: _obscureConfirmPassword
                                      ? SvgPicture.asset('assets/svg/eye-slash.svg', width: 24.w, height: 24.h)
                                      : SvgPicture.asset('assets/svg/eye_open.svg', width: 24.w, height: 24.h),
                                ),
                                validator: _validateConfirmPassword,
                                textInputAction: TextInputAction.done,
                              ),
                              SizedBox(height: 32.h),

                              // Submit Button 
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  if (state is ChangePasswordLoading) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  return CustomButton(
                                    text: 'Update Password',
                                    onPressed: _handleChangePassword,
                                    width: double.infinity,
                                    backgroundColor: const Color(0xFF1A1A1A),
                                  );
                                },
                              ),
                              SizedBox(height: 24.h), 
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}