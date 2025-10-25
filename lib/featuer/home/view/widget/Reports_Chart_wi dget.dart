import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsAnalyticsChart extends StatelessWidget {
  const ReportsAnalyticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SalesData> data = [
      _SalesData('Jan', 3200, 3800),
      _SalesData('Feb', 2100, 3400),
      _SalesData('Mar', 2500, 3700),
      _SalesData('Apr', 1600, 2900),
      _SalesData('May', 2200, 3300),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reports & Analytics",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      "Weekly",
                      style:
                          TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chart
          SfCartesianChart(
            margin: EdgeInsets.zero,
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 4000,
              interval: 1000,
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            series:[
              // Total Customers
              SplineAreaSeries<_SalesData, String>(
                dataSource: data,
                color: Colors.blue.withOpacity(0.15),
                borderColor: Colors.blue.shade200,
                borderWidth: 2,
                xValueMapper: (_SalesData d, _) => d.month,
                yValueMapper: (_SalesData d, _) => d.total,
                name: 'Total Customers',
              ),
              // New Customers
              SplineAreaSeries<_SalesData, String>(
                dataSource: data,
                color: Colors.orange.withOpacity(0.15),
                borderColor: Colors.orange,
                borderWidth: 2,
                xValueMapper: (_SalesData d, _) => d.month,
                yValueMapper: (_SalesData d, _) => d.newCustomers,
                name: 'New Customers',
              ),
            ],
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              iconHeight: 12,
              iconWidth: 12,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  final String month;
  final double newCustomers;
  final double total;

  _SalesData(this.month, this.newCustomers, this.total);
}
