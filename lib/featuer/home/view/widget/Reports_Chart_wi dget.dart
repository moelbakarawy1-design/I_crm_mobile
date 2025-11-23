import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:admin_app/featuer/home/manager/dashboard_cubit.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';

class ReportsAnalyticsChart extends StatelessWidget {
  final List<ChartData> chartData;

  const ReportsAnalyticsChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 394.w,
      height: 360.h,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainWhite,
            AppColor.primaryWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.secondaryWhite,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainBlue.withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chat Activity",
                    style: AppTextStyle.setpoppinsSecondaryBlack(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Real-time overview",
                    style: AppTextStyle.setipoppinssecondaryGery(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.mainBlue.withOpacity(0.1),
                      AppColor.lightPurple.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.mainBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: AppColor.mainBlue,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Recent",
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.mainBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                labelStyle: AppTextStyle.setipoppinssecondaryGery(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                interval: 1,
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: AppColor.secondaryWhite,
                  dashArray: [5, 5],
                ),
                labelStyle: AppTextStyle.setipoppinssecondaryGery(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: AppColor.secondaryBlack,
                textStyle: AppTextStyle.setpoppinsWhite(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              series: [
                SplineAreaSeries<ChartData, String>(
                  dataSource: chartData,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.mainBlue.withOpacity(0.4),
                      AppColor.lightPurple.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      AppColor.mainBlue,
                      AppColor.lightPurple,
                    ],
                  ),
                  borderWidth: 3,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  name: 'Chats',
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    height: 8,
                    width: 8,
                    borderWidth: 3,
                    borderColor: AppColor.mainBlue,
                    color: AppColor.mainWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}