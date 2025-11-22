import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColor.mainWhite,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.mainBlack.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorIcon(),
            SizedBox(height: 20.h),
            _buildTitle(),
            SizedBox(height: 8.h),
            _buildMessage(),
            SizedBox(height: 24.h),
            _buildRetryButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 48.sp,
        color: Colors.redAccent,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Oops! Something went wrong',
      style: AppTextStyle.setpoppinsBlack(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildMessage() {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyle.setipoppinssecondaryGery(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildRetryButton() {
    return TextButton(
      onPressed: onRetry,
      style: TextButton.styleFrom(
        backgroundColor: AppColor.mainBlue.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      child: Text(
        'Try Again',
        style: AppTextStyle.setpoppinsTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.mainBlue,
        ),
      ),
    );
  }
}