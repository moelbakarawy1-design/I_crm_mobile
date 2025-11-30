import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/helper/eror_snackBar_helper.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:admin_app/featuer/role/helper/Function_helper.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchRoles();
      }
    });
  }

  Future<void> _fetchRoles() async {
    context.read<InvitationCubit>().fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CustomAppBar(
        title: 'Role',
        onMenuPressed: () => Navigator.pop(context),
      ),
      body: BlocListener<InvitationCubit, InvitationState>(
        listener: (context, state) {
          if (state is CreateRoleSuccess ||
              state is UpdateRoleSuccess ||
              state is DeleteRoleSuccess) {
            String message = 'Role updated successfully';
            if (state is CreateRoleSuccess) message = 'Role created successfully';
            if (state is DeleteRoleSuccess) message = 'Role deleted successfully';

            showTopError(context, message);
          } else if (state is CreateRoleFailure ||
              state is UpdateRoleFailure ||
              state is DeleteRoleFailure) {
            String errorMessage = 'An unknown error occurred';
            if (state is CreateRoleFailure) errorMessage = state.errorMessage;
            if (state is UpdateRoleFailure) errorMessage = state.errorMessage;
            if (state is DeleteRoleFailure) errorMessage = state.errorMessage;

            showTopError(context, errorMessage);
          }
        },
        child: RefreshIndicator(
          onRefresh: _fetchRoles,
          color: AppColor.mainBlue,
          child: BlocBuilder<InvitationCubit, InvitationState>(
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
                return buildError(state.errorMessage, context);
              }
              if (state is RolesSuccess) {
                final roles = state.roles;
                if (roles.isEmpty) {
                  return buildEmptyState();
                }
                return buildRoleList(roles);
              }
              return buildEmptyState();
            },
          ),
        ),
      ),
      
      floatingActionButton: FutureBuilder<bool>(
        future: LocalData.hasEnumPermission(Permission.CREATE_ROLE),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == false) {
            return const SizedBox.shrink();
          }
          // If Permission Granted, Show Button
          return FloatingActionButton.extended(
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
          );
        },
      ),
    );
  }
}