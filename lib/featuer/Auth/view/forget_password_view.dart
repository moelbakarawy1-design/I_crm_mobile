import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
import 'package:admin_app/featuer/Auth/view/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // --- 1. Update the handle method to call the Cubit ---
  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      // Call the cubit method
      AuthCubit.get(context).forgetPassword(
        email: _emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E87F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: SvgPicture.asset(
                  AppAssetsUtils.forgetPassword,
                  width: 308.w,
                  height: 205.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              // --- 2. Add BlocConsumer to listen for states ---
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ForgetPasswordLoading) {
                    // Show a loading dialog
                    DialogUtils.showLoadingDialog(
                        context, 'Sending Code...');
                  } 
                  else if (state is ForgetPasswordSuccess) {
                  
                   Navigator.of(context,rootNavigator: true).pop();
                    Navigator.pushNamed(
                      context,
                      Routes.sendOtp,
                      arguments: state.resendCodeToken,
                    );
                  } else if (state is ForgetPasswordError) {
                    Navigator.of(context, rootNavigator: true).pop();

                    SnackbarUtils.showErrorSnackbar(
                      context,
                      state.message,
                    );
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is ForgetPasswordLoading;

                  return Container(
                    width: double.infinity,
                    height: 716.h,
                    decoration: BoxDecoration(
                      color: AppColor.mainWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
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
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Please enter your email for sending OTP',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'Email',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextFormField(
                              controller: _emailController,
                              hintText: 'youremail@yahoo.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: FieldValidator.email,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 24.h),
                            CustomButton(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              text: 'Send Code',
                              // Disable button when loading
                              onPressed:
                                  isLoading ? null : _handleForgotPassword,
                              width: double.infinity,
                              backgroundColor: const Color(0xFF1A1A1A),
                            ),
                            SizedBox(height: 24.h),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remember Password?',
                                    style: AppTextStyle.setpoppinsSecondlightGrey(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Back to Sign',
                                      style: AppTextStyle.setpoppinsBlack(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}