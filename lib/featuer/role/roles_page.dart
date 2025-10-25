// lib/feature/roles/presentation/views/roles_page.dart
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
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
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              InvitationCubit.get(context).fetchRoles();
            },
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
              child: CircularProgressIndicator(
                color: Color(0xFF0E87F8),
              ),
            );
          }

          if (state is RolesFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80.w,
                      color: Colors.red,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Error Loading Roles',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        InvitationCubit.get(context).fetchRoles();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E87F8),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final roles = InvitationCubit.get(context).roles;

          if (roles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    size: 100.w,
                    color: const Color(0xFFE0E0E0),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'No Roles Available',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Create a role to get started',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with count
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Roles',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E87F8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${roles.length} Roles',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0E87F8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Roles List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    return _RoleCard(role: role);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add role page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add role feature coming soon')),
          );
        },
        backgroundColor: const Color(0xFF0E87F8),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Role',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Role Card Widget
class _RoleCard extends StatelessWidget {
  final RoleModel role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showRoleDetails(context, role);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (role.permissions != null && role.permissions!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          '${role.permissions!.length} permissions',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit role feature coming soon')),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      color: const Color(0xFF9E9E9E),
                      iconSize: 20.w,
                    ),
                    IconButton(
                      onPressed: () {
                        _showRoleOptions(context, role);
                      },
                      icon: const Icon(Icons.more_vert),
                      color: const Color(0xFF9E9E9E),
                      iconSize: 20.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRoleOptions(BuildContext context, RoleModel role) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.visibility, color: Color(0xFF0E87F8)),
              title: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRoleDetails(context, role);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF0E87F8)),
              title: Text(
                'Edit Role',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit role feature coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete Role',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, role);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _showRoleDetails(BuildContext context, RoleModel role) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E87F8).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: const Color(0xFF0E87F8),
                    size: 28.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ID: ${role.id}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (role.permissions != null && role.permissions!.isNotEmpty) ...[
              Text(
                'Permissions',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 12.h),
              ...role.permissions!.map((permission) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20.w,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        permission,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(height: 24.h),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E87F8),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, RoleModel role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to delete "${role.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete role feature coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}