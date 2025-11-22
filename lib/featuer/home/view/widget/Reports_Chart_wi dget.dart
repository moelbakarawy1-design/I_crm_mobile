import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// Import ChartData from the Cubit file (or wherever you moved it)
import 'package:admin_app/featuer/home/manager/dashboard_cubit.dart';

class ReportsAnalyticsChart extends StatelessWidget {
  final List<ChartData> chartData;

  const ReportsAnalyticsChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 394.w,
      height: 360.h,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Chat Activity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Recent", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: 10.sp),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                interval: 1, 
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: [
                SplineAreaSeries<ChartData, String>(
                  dataSource: chartData,
                  color: Colors.blue.withOpacity(0.15),
                  borderColor: Colors.blue.shade200,
                  borderWidth: 2,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y,
                  name: 'Chats',
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}