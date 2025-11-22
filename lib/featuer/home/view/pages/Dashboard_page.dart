import 'package:admin_app/featuer/home/data/repo/DashboardRepo.dart';
import 'package:admin_app/featuer/home/manager/dashboard_cubit.dart';
import 'package:admin_app/featuer/home/manager/dashboard_state.dart';
import 'package:admin_app/featuer/home/view/widget/Reports_Chart_wi%20dget.dart';
import 'package:admin_app/featuer/home/view/widget/messageStatesChart.dart';
import 'package:admin_app/featuer/home/view/widget/cusstom_static_card_widget.dart';
import 'package:admin_app/featuer/home/view/widget/sales_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(DashboardRepository())..fetchDashboardData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is DashboardSuccess) {
              final data = state.data;
              final cubit = context.read<DashboardCubit>();
              
              final chatActivityData = cubit.getChatsPerDay(data.latestChats);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                            
                    ReportsAnalyticsChart(chartData: chatActivityData),
                          SizedBox(height: 20.h),
                          StatisticCard(
                            title: 'Total Customers',
                            value: '${data.counts?.customers ?? 0}',
                            iconPath: 'assets/svg/Icon_cusstomer.svg',
                          ),
                          SizedBox(height: 15.h),
                          StatisticCard(
                            title: 'Active Users',
                            value: '${data.counts?.users ?? 0}',
                            iconPath: 'assets/svg/IconActiveCusstomer.svg',
                          ),
                        ],
                      ),
                    ),
                    
                    if (data.messageStats != null)
                      MessageStatsChart(stats: data.messageStats!),
                      
                    if (data.chatsPerUser != null)
                      SalesTable(userData: data.chatsPerUser!),                                      
                    SizedBox(height: 50.h),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}