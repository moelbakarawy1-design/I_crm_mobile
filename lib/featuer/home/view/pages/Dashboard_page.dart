import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/responsive_layout.dart';
import 'package:admin_app/featuer/home/data/repo/DashboardRepo.dart';
import 'package:admin_app/featuer/home/manager/dashboard_cubit.dart';
import 'package:admin_app/featuer/home/manager/dashboard_state.dart';
import 'package:admin_app/featuer/home/view/widget/Reports_Chart_wi%20dget.dart';
import 'package:admin_app/featuer/home/view/widget/cusstom_static_card_widget.dart';
import 'package:admin_app/featuer/home/view/widget/sales_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: LocalData.getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final String? userRole = snapshot.data;
        final bool isAllowed =
            userRole != null &&
            (userRole.toLowerCase() == 'admin' ||
                userRole.toLowerCase() == 'manager');

        if (!isAllowed) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 70.sp, color: AppColor.lightBlue),
                  SizedBox(height: 16.h),
                  Text(
                    "Access Restricted",
                    style: AppTextStyle.setpoppinsBlack(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Current Role: ${userRole ?? 'None'}\nOnly Admins & Managers allowed.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.setpoppinsSecondaryBlack(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // SUCCESS: Show Dashboard
        return BlocProvider(
          create: (context) =>
              DashboardCubit(DashboardRepository())..fetchDashboardData(),
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
                  final chatActivityData = cubit.getChatsPerDay(
                    data.latestChats,
                  );

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        ResponsiveLayout(
                          mobile: _buildMobileLayout(data, chatActivityData),
                          tablet: _buildWideLayout(data, chatActivityData),
                          desktop: _buildWideLayout(data, chatActivityData),
                        ),

                        // Sales Table is always full width at bottom
                        if (data.chatsPerUser != null)
                          Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: SalesTable(userData: data.chatsPerUser!),
                          ),

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
      },
    );
  }

  // Mobile Layout: Vertical Stack
  Widget _buildMobileLayout(dynamic data, dynamic chatActivityData) {
    return Column(
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
    );
  }

  // Wide/Tablet Layout: Chart on Left, Cards on Right
  Widget _buildWideLayout(dynamic data, dynamic chatActivityData) {
    // Re-initialize ScreenUtil for Desktop/Tablet to prevent huge scaling
    return ScreenUtilInit(
      designSize: const Size(1440, 900), // Standard Desktop Design Size
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart takes 65% of width
            Expanded(
              flex: 65,
              child: ReportsAnalyticsChart(chartData: chatActivityData),
            ),
            SizedBox(width: 20.w),
            // Cards take 35% of width
            Expanded(
              flex: 35,
              child: Column(
                children: [
                  StatisticCard(
                    title: 'Total Customers',
                    value: '${data.counts?.customers ?? 0}',
                    iconPath: 'assets/svg/Icon_cusstomer.svg',
                  ),
                  SizedBox(height: 20.h), // Consistent spacing
                  StatisticCard(
                    title: 'Active Users',
                    value: '${data.counts?.users ?? 0}',
                    iconPath: 'assets/svg/IconActiveCusstomer.svg',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
