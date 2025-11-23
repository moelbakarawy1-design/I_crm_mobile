import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';

class MessageStatsChart extends StatelessWidget {
  final List<MessageStat> stats;

  const MessageStatsChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainWhite,
            AppColor.primaryWhite,
          ],
        ),
        border: Border.all(
          color: AppColor.secondaryWhite,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.lightPurple.withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Message Statistics',
                    style: AppTextStyle.setpoppinsSecondaryBlack(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Performance insights',
                    style: AppTextStyle.setipoppinssecondaryGery(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.lightPurple.withOpacity(0.1),
                      AppColor.mainBlue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.lightPurple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14.sp,
                      color: AppColor.lightPurple,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Weekly',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),

          // Chart
          SizedBox(
            height: 250.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: AppTextStyle.setipoppinssecondaryGery(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                labelIntersectAction: AxisLabelIntersectAction.rotate45,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: MajorGridLines(
                  color: AppColor.secondaryWhite,
                  width: 1,
                  dashArray: [5, 5],
                ),
                labelStyle: AppTextStyle.setipoppinssecondaryGery(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                canShowMarker: false,
                color: AppColor.secondaryBlack,
                textStyle: AppTextStyle.setpoppinsWhite(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                shadowColor: Colors.transparent,
              ),
              series: [
                ColumnSeries<MessageStat, String>(
                  dataSource: stats,
                  xValueMapper: (MessageStat d, _) => d.type,
                  yValueMapper: (MessageStat d, _) => d.count,
                  name: 'Messages',
                  width: 0.6,
                  spacing: 0.2,
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.lightPurple,
                      AppColor.mainBlue,
                      AppColor.lightBlue,
                    ],
                    stops: const [0.0, 0.5, 1.0],
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