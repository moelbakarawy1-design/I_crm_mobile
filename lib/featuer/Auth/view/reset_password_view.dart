import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
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

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      // Add your reset password logic here
      print('New Password: ${_newPasswordController.text}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully!')),
      );
      
      // Navigate back to login page
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.logInView,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E90FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: SvgPicture.asset(
                  AppAssetsUtils.resetPassword,
                  width: 280.w,
                  height: 280.h,
                  fit: BoxFit.contain,
                ),
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
                          'Reset Password',
                          style:AppTextStyle.setpoppinsBlack(fontSize: 32, fontWeight: FontWeight.w700)
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter your password below',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w400)
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'New Password',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: _newPasswordController,
                          hintText: 'Enter new password',
                          obscureText: _obscureNewPassword,
                        suffixIcon: IconButton(
  onPressed: () {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  },
  icon: _obscureConfirmPassword
      ? SvgPicture.asset(
          'assets/svg/eye-slash.svg',
          width: 24.w,
          height: 24.h,
          fit: BoxFit.scaleDown,
        )
      : SvgPicture.asset(
          'assets/svg/eye_open.svg',
          width: 24.w,
          height: 24.h,
          fit: BoxFit.scaleDown,
        )
                           
                          ),
                          validator: FieldValidator.password,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Confirm Password',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm new password',
                          obscureText: _obscureConfirmPassword,
suffixIcon: IconButton(
  onPressed: () {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  },
  icon: _obscureConfirmPassword
      ? SvgPicture.asset(
          'assets/svg/eye-slash.svg',
          width: 24.w,
          height: 24.h,
            fit: BoxFit.scaleDown,
        )
      :  SvgPicture.asset(
          'assets/svg/eye_open.svg',
          width: 24.w,
          height: 24.h,
          fit: BoxFit.scaleDown,
        )                         
                          ),
                          validator: _validateConfirmPassword,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: 'Reset Password',
                          onPressed: _handleResetPassword,
                          width: double.infinity,
                          backgroundColor: const Color(0xFF1A1A1A),
                        ),
                        SizedBox(height: 24.h),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password? ',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF9E9E9E),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.logInView,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}