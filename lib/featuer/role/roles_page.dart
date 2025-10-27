import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:admin_app/featuer/role/widget/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  void initState() {
    super.initState();
    InvitationCubit.get(context).fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.home);
          },
          icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
        ),
        title: Text(
          'Role',
          style: TextStyle(
            color: const Color(0xFF0E87F8),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => InvitationCubit.get(context).fetchRoles(),
            icon: const Icon(Icons.refresh, color: Color(0xFF1A1A1A)),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<InvitationCubit, InvitationState>(
        buildWhen: (previous, current) =>
            current is RolesLoading ||
            current is RolesSuccess ||
            current is RolesFailure,
        builder: (context, state) {
          if (state is RolesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0E87F8)),
            );
          }

          if (state is RolesFailure) {
            return _buildError(state.errorMessage);
          }

          final roles = InvitationCubit.get(context).roles;

          if (roles.isEmpty) {
            return _buildEmptyState();
          }

          return _buildRoleList(roles);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add role feature coming soon')),
          );
        },
        backgroundColor: const Color(0xFF1570EF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Role',
          style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.mainWhite)
        ),
      ),
    );
  }

  Widget _buildError(String message) => Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.w, color: Colors.red),
              SizedBox(height: 24.h),
              Text('Error Loading Roles',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A))),
              SizedBox(height: 12.h),
              Text(message,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14.sp, color: const Color(0xFF9E9E9E))),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () => InvitationCubit.get(context).fetchRoles(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E87F8),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 32.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings_outlined,
                size: 100.w, color: const Color(0xFFE0E0E0)),
            SizedBox(height: 24.h),
            Text('No Roles Available',
                          style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0XFF292D32))
),
            SizedBox(height: 8.h),
            Text('Create a role to get started',
                style: TextStyle(
                    fontSize: 14.sp, color: const Color(0xFF9E9E9E))),
          ],
        ),
      );

  Widget _buildRoleList(List<RoleModel> roles) => Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Roles',
                style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0XFF292D32))
),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E87F8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text('${roles.length} Roles',
                               style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0XFF292D32))
),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: roles.length,
              itemBuilder: (context, index) =>
                  RoleCard(role: roles[index]),
            ),
          ),
        ],
      );
}
