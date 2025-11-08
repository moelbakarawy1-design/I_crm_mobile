import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart'; // Assuming you have this
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
    
    // ✅ FIX: Call fetchRoles AFTER the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchRoles(); // Call your function
      }
    });
  }

  Future<void> _fetchRoles() async {
    // ✅ LOG: Log when the fetch starts
    print("--- 1. RolesPage: Calling _fetchRoles... ---");
    context.read<InvitationCubit>().fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        centerTitle: true,
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
          style: AppTextStyle.setpoppinsTextStyle(
            color: AppColor.mainBlack,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // ✅ ADDED: BlocListener to show SnackBars for create/update/delete
      body: BlocListener<InvitationCubit, InvitationState>(
        listener: (context, state) {
          if (state is CreateRoleSuccess ||
              state is UpdateRoleSuccess ||
              state is DeleteRoleSuccess) {
            String message = 'Role updated successfully';
            if (state is CreateRoleSuccess) message = 'Role created successfully';
            if (state is DeleteRoleSuccess) message = 'Role deleted successfully';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(message), backgroundColor: Colors.green),
            );
          }
          else if (state is CreateRoleFailure ||
              state is UpdateRoleFailure ||
              state is DeleteRoleFailure) {
            String errorMessage = 'An unknown error occurred';
            if (state is CreateRoleFailure) errorMessage = state.errorMessage;
            if (state is UpdateRoleFailure) errorMessage = state.errorMessage;
            if (state is DeleteRoleFailure) errorMessage = state.errorMessage;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: _fetchRoles,
          color: AppColor.mainBlue, // Use your app's primary color
          child: BlocBuilder<InvitationCubit, InvitationState>(
            buildWhen: (previous, current) =>
                current is RolesLoading ||
                current is RolesSuccess ||
                current is RolesFailure,
            builder: (context, state) {
              // ✅ LOG: Log what state the builder is receiving
              print("--- 2. RolesPage: BlocBuilder received state: ${state.runtimeType} ---");

              if (state is RolesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0E87F8)),
                );
              }

              if (state is RolesFailure) {
                return _buildError(state.errorMessage, context);
              }

              if (state is RolesSuccess) {
                final roles = state.roles;
                if (roles.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildRoleList(roles);
              }

              // Default to empty state
              return _buildEmptyState();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, Routes.createRolePage);
        },
        backgroundColor: const Color(0xFF1570EF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Role',
            style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.mainWhite)),
      ),
    );
  }

  Widget _buildError(String message, BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.w, color: Colors.red),
              SizedBox(height: 24.h),
              Text('Error Loading Roles',
                  style: AppTextStyle.setpoppinsTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A))),
              SizedBox(height: 12.h),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.setpoppinsTextStyle(
                      fontSize: 14.sp, color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w500)),
              SizedBox(height: 32.h),
              CustomButton(
                onPressed: () {
                  // ✅ LOG: Log when the Retry button is pressed
                  print("--- 3. RolesPage: 'Retry' button pressed. ---");
                  _fetchRoles();
                },
                text: 'Retry',
                icon: const Icon(Icons.refresh, color: Colors.white),
                width: 150.w,
                height: 48.h,
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
                style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 16.sp, 
                    fontWeight: FontWeight.w600,
                    color: const Color(0XFF292D32))),
            SizedBox(height: 8.h),
            Text('Create a role to get started',
                style: AppTextStyle.setpoppinsTextStyle(
                    fontSize: 14.sp, color: const Color(0xFF9E9E9E), fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _buildRoleList(List<RoleModel> roles) => Column(
        children: [
          Container(
            // ... (your existing code is fine) ...
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: roles.length,
              itemBuilder: (context, index) => RoleCard(role: roles[index]),
            ),
          ),
        ],
      );
}