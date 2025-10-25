import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/home/data/model/sales_data.dart';
import 'package:admin_app/featuer/home/view/widget/Reports_Chart_wi%20dget.dart';
import 'package:admin_app/featuer/home/view/widget/calls_card_widget.dart';
import 'package:admin_app/featuer/home/view/widget/cusstom_static_card_widget.dart';
import 'package:admin_app/featuer/home/view/widget/sales_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CallsData> data = [
      _CallsData('Jan', 300, 420),
      _CallsData('Feb', 450, 510),
      _CallsData('Mar', 480, 460),
      _CallsData('Apr', 350, 400),
      _CallsData('May', 390, 440),
    ];
  final List<SalesPerson> salesData = SalesData.getSalesData();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.mainWhite,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title + Weekly Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calls per Month',
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
          
                // Chart
                SizedBox(
                  height: 250.h,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      axisLine: const AxisLine(width: 0),
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      majorGridLines: MajorGridLines(color: Colors.grey.shade300),
                      labelStyle: const TextStyle(fontSize: 11),
                    ),
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      iconHeight: 10,
                      iconWidth: 10,
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series:[
                    ColumnSeries<_CallsData, String>(
                       dataSource: data,
                       xValueMapper: (_CallsData d, _) => d.month,
                       yValueMapper: (_CallsData d, _) => d.unsuccessful,
                       name: 'Unsuccessful',
                       width: 0.4,
                       spacing: 0.2,
                       borderRadius: const BorderRadius.all(Radius.circular(4)),

                      //  Apply gradient color
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

                     ColumnSeries<_CallsData, String>(
                    dataSource: data,
                    xValueMapper: (_CallsData d, _) => d.month,
                    yValueMapper: (_CallsData d, _) => d.successful,
                    name: 'Successful',
                    width: 0.4,
                    spacing: 0.2,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    // ✅ Apply gradient:
                    onCreateShader: (ShaderDetails details) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end:  Alignment.bottomCenter,
                        colors: [
                          Color(0xFF46A46C),
                          Color(0xFF51CC5D),
                          Color(0xFF57DA65),
                        ],
                        stops: [0.0, 0.48, 1.0], // same as your CSS percentages
                      ).createShader(details.rect);
                      },
                     ),

                    ],
                  ),
                ),
               
              ],
            ),
          ),
          SingleChildScrollView(child: SizedBox(
            height: 250.h,
            child: SalesTable(salesData:salesData ,))),
         SizedBox(
          height: 200.h,
          child: CallsTodayCard()),
          SizedBox(height: 15.h,),
          StatisticCard(title: 'Total Customers', value: '+2000', iconPath: 'assets/svg/Icon_cusstomer.svg',),
           SizedBox(height: 15.h,),
          StatisticCard(title: 'Active Customers', value: '+800', iconPath: 'assets/svg/IconActiveCusstomer.svg',),
          SizedBox(
            height: 350.h,
            child: ReportsAnalyticsChart())
        ],
      ),
    );
  }
}

class _CallsData {
  final String month;
  final double unsuccessful;
  final double successful;
  _CallsData(this.month, this.unsuccessful, this.successful);
}
