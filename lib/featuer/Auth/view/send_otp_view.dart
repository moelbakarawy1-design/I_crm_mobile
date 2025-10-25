import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendOtpView extends StatefulWidget {
  final String email;
  
  const SendOtpView({super.key, required this.email});

  @override
  State<SendOtpView> createState() => _SendOtpViewState();
}

class _SendOtpViewState extends State<SendOtpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _remainingTime--;
          if (_remainingTime <= 0) {
            _canResend = true;
          } else {
            _startTimer();
          }
        });
      }
    });
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      // Add your OTP verification logic here
      print('OTP: ${_otpController.text}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully!')),
      );
      
      // Navigate to reset password page
      Navigator.pushNamed(context, Routes.resetPassword);
    }
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        _remainingTime = 60;
        _canResend = false;
      });
      _startTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent again!')),
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
                          'OTB Verification',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 32, fontWeight: FontWeight.w700)
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Please enter a code from email',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 14, fontWeight: FontWeight.w400)
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'Your code',
                          style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: _otpController,
                          hintText: 'Enter 6-digit OTP',
                          keyboardType: TextInputType.number,
                          validator: FieldValidator.otp,
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
                                  style: AppTextStyle.setpoppinsTextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0E87F8),)
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
                                  onTap: _resendOtp,
                                  child: Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: 'Verification',
                          onPressed: _handleVerifyOtp,
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
                                  style: AppTextStyle.setpoppinsSecondaryBlack(fontSize: 12, fontWeight: FontWeight.w600)
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