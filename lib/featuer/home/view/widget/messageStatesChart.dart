import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MessageStatsChart extends StatelessWidget {
  final List<MessageStat> stats;

  const MessageStatsChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        // Exact border style from your reference image
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Message Statistics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: const Text('Weekly'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  textStyle: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Chart
          SizedBox(
            height: 250.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
                labelIntersectAction: AxisLabelIntersectAction.rotate45,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: MajorGridLines(color: Colors.grey.shade200),
                labelStyle: const TextStyle(fontSize: 11),
              ),
              tooltipBehavior: TooltipBehavior(enable: true, header: '', canShowMarker: false),
              series: [
                ColumnSeries<MessageStat, String>(
                  dataSource: stats,
                  xValueMapper: (MessageStat d, _) => d.type,
                  yValueMapper: (MessageStat d, _) => d.count,
                  name: 'Messages',
                  width: 0.5,
                  borderRadius: BorderRadius.circular(6),
                  // The Blue/Purple/LightBlue gradient style
                  onCreateShader: (ShaderDetails details) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF817AF3),
                        Color(0xFF74B0FA),
                        Color(0xFF79D0F1),
                      ],
                      stops: [0.0, 0.48, 1.0],
                    ).createShader(details.rect);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}