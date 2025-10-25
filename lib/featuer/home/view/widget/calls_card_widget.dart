import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';

class CallsTodayCard extends StatefulWidget {
  const CallsTodayCard({super.key});

  @override
  State<CallsTodayCard> createState() => _CallsTodayCardState();
}

class _CallsTodayCardState extends State<CallsTodayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: 330.w,
          height: 163.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.mainWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Our Calls Today',
                style: AppTextStyle.setpoppinsSecondaryBlack(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 18.h),

              // Two sections
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/Suppliers.svg',
                          width: 30.w,
                          height: 30.h,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '31',
                          style: AppTextStyle.setpoppinsSecondaryBlack(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Completed Calls',
                          style: AppTextStyle.setpoppinsSecondaryBlack(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    // Vertical Divider
                    Container(
                      width: 1,
                      height: 70.h,
                      color: AppColor.grey.withOpacity(0.5),
                    ),

                    // Right section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/Categories (1).svg',
                          width: 30.w,
                          height: 30.h,
                          fit: BoxFit.scaleDown,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '10',
                          style: AppTextStyle.setpoppinsSecondaryBlack(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Missed Calls',
                          style: AppTextStyle.setpoppinsSecondaryBlack(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
