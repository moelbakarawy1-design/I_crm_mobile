import 'dart:async'; 

import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
import 'package:admin_app/featuer/Auth/view/utils/dialog_utils.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SendOtpView extends StatefulWidget {
  final String email;

  const SendOtpView({super.key, required this.email});

  @override
  State<SendOtpView> createState() => _SendOtpViewState();
}

class _SendOtpViewState extends State<SendOtpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  // --- Improved Timer Logic ---
  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer on dispose
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _remainingTime = 60;
    });
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _timer?.cancel();
            _canResend = true;
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  // --- 1. Update Verify method to call Cubit ---
  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      // Call cubit to verify
      AuthCubit.get(context).verifyOtp(
        email: widget.email,
        code: _otpController.text,
      );
    }
  }

  // --- 2. Update Resend method to call Cubit ---
  void _resendOtp() {
    if (_canResend) {
      // Call cubit to resend (using forgetPassword)
      AuthCubit.get(context).forgetPassword(email: widget.email);
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
              flex: 5,
              child: SizedBox.expand(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 15.h,
                      left: 80.w,
                      child: Opacity(
                        opacity: 1,
                        child: Transform.rotate(
                          angle: 0, // radians
                          child: SvgPicture.asset(
                            AppAssetsUtils.sendOtp,
                            width: 327.w,
                            height: 260.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 12,
              // --- 3. Add BlocConsumer to listen for states ---
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  // --- Verify OTP States ---
                  if (state is VerifyOtpLoading) {
                    DialogUtils.showLoadingDialog(context, 'Verifying Code...');
                  } else if (state is VerifyOtpSuccess) {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // Pop dialog
                    SnackbarUtils.showSuccessSnackbar(
                        context, state.message);

                    // Navigate to reset password page and PASS THE TOKEN
                    Navigator.pushNamed(
                      context,
                      Routes.resetPassword,
                      arguments: state.token, // Pass the token!
                    );
                  } else if (state is VerifyOtpError) {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // Pop dialog
                    SnackbarUtils.showErrorSnackbar(context, state.message);
                  }

                  // --- Resend OTP States (ForgetPassword) ---
                  else if (state is ForgetPasswordLoading) {
                    // Show a simple snackbar for resend loading
                    SnackbarUtils.showSuccessSnackbar(
                        context, 'Sending new code...',
                        );
                  } else if (state is ForgetPasswordSuccess) {
                    SnackbarUtils.showSuccessSnackbar(
                        context, state.message);
                    _startTimer(); // Restart the timer on success
                  } else if (state is ForgetPasswordError) {
                    SnackbarUtils.showErrorSnackbar(context, state.message);
                    setState(() {
                      _canResend = true; // Allow user to try again
                    });
                  }
                },
                builder: (context, state) {
                  // Disable button if verifying
                  bool isVerifying = state is VerifyOtpLoading;
                  // Disable resend if not allowed or loading
                  bool isResending = state is ForgetPasswordLoading;

                  return Container(
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
                              'OTP Verification',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 32, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Please enter code sent to ${widget.email}', // Show email
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'Your code',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8.h),
                            CustomTextFormField(
                              controller: _otpController,
                              hintText: 'Enter 6-digit OTP',
                              keyboardType: TextInputType.number,
                              
                              textInputAction: TextInputAction.done,
                              maxLength: 6,
                            ),
                            SizedBox(height: 16.h),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!_canResend) ...[
                                    Text(
                                      'Resend OTP in ',
                                      style: AppTextStyle.setpoppinsTextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0E87F8),
                                      ),
                                    ),
                                    Text(
                                      '$_remainingTime',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Text(
                                      's',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ] else
                                    GestureDetector(
                                      onTap:
                                          isResending ? null : _resendOtp,
                                      child: Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isResending
                                              ? Colors.grey
                                              : const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            CustomButton(
                              text: 'Verification',
                              onPressed:
                                  isVerifying ? null : _handleVerifyOtp,
                              width: double.infinity,
                              backgroundColor: const Color(0xFF1A1A1A),
                            ),
                            SizedBox(height: 24.h),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Wrong email? ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Go Back',
                                      style:
                                          AppTextStyle.setpoppinsSecondaryBlack(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
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

