import 'package:admin_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle setpoppinsTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }){
    return GoogleFonts.poppins(
      
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle setpoppinsWhite({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.mainWhite,
    );
  }

  static TextStyle setpoppinsSecondaryBlack({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.secondaryBlack,
    );
  }

  static TextStyle setpoppinsSecondlightGrey({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.secondeLightGrey,
    );
  }

  static TextStyle setipoppinssecondaryGery({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.secondaryGrey,
    );
  }

  static TextStyle setpoppinsBlack({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.mainBlack,
    );
  }
   static TextStyle setpoppinsDeepPurple({
    required double fontSize,
    required FontWeight fontWeight,
  }){
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColor.lightPurple,
    );
  }
}