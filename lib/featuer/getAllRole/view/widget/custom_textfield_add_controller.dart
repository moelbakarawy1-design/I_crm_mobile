import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFieldAddController extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? prefixSvgIcon; // <-- changed to SVG path
  final String? suffixSvgIcon; // <-- changed to SVG path
  final VoidCallback? onSuffixTap;
  final bool readOnly;

  const CustomTextFieldAddController({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixSvgIcon,
    this.suffixSvgIcon,
    this.onSuffixTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.w,
      height: 50.h, 

      child: TextFormField(
        controller: controller,
        
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        readOnly: readOnly,
        style: AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0XFF7E92A2)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0XFFF6FAFD),
          hintStyle: AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0XFF7E92A2)) ,
          labelStyle: AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0XFF7E92A2)) ,
          labelText: labelText,
          hintText: hintText,
          // ✅ Prefix SVG Icon
          prefixIcon: prefixSvgIcon != null
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    fit: BoxFit.scaleDown,
                    prefixSvgIcon!,
                    width: 16.25.w,
                    height: 17.77.h,
                    colorFilter: ColorFilter.mode(
                      AppColor.gray70,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : null,

          // ✅ Suffix SVG Icon with tap
          suffixIcon: suffixSvgIcon != null
              ? InkWell(
                  onTap: onSuffixTap,
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      fit: BoxFit.scaleDown,
                      suffixSvgIcon!,
                      width: 16.25.w,
                    height: 17.77.h,
                      colorFilter: ColorFilter.mode(
                        AppColor.gray70,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Color(0xFFEAEEF4),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Color(0xFFEAEEF4),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Color(0xFFEAEEF4), // Light blue when focused
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
class FieldValidator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != length) {
      return 'OTP must be $length digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }
}
