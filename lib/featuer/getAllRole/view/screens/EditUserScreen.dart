import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/custom_textfield_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditUserScreen extends StatefulWidget {
  final Data user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  RoleModel? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    context.read<InvitationCubit>().fetchRoles();

    if (widget.user.role != null) {
      _selectedRole = RoleModel(
        id: widget.user.role!.id!,
        name: widget.user.role!.name!,
      );
    }
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      // Track which fields have changed
      String? updatedName;
      String? updatedRoleId;

      // Check if name has changed
      if (_nameController.text.trim() != (widget.user.name ?? '')) {
        updatedName = _nameController.text.trim();
      }

      // Check if role has changed
      if (_selectedRole != null &&
          _selectedRole!.id.toString() != widget.user.role?.id?.toString()) {
        updatedRoleId = _selectedRole!.id.toString();
      }

      // Validate that at least one field has changed
      if (updatedName == null && updatedRoleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No changes detected"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Send only the changed fields (email is excluded as it's read-only)
      context.read<GetAllUserCubit>().updateUser(
        userId: widget.user.id!,
        name: updatedName,
        roleId: updatedRoleId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit User'),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 170, 25, 100),
            child: Container(
              width: 388.w,
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit User',
                          style: AppTextStyle.setpoppinsTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0XFF092C4C),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            'assets/svg/Button.svg',
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    /// Name Field
                    Text(
                      'Name',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0XFF667085),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFieldAddController(
                      suffixSvgIcon: 'assets/svg/edit-2.svg',
                      controller: _nameController,
                      hintText: 'Enter name',
                      labelText: 'Name',
                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                    ),
                    SizedBox(height: 20.h),

                    /// Email Field
                    Text(
                      'Email',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0XFF667085),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFieldAddController(
                      suffixSvgIcon: 'assets/svg/edit-2.svg',
                      controller: _emailController,
                      hintText: 'Enter email',
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                      validator: (v) => v!.isEmpty ? 'Email is required' : null,
                    ),
                    SizedBox(height: 15.h),

                    /// Role Dropdown
                    Text(
                      'Role',
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFF667085),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    BlocBuilder<InvitationCubit, InvitationState>(
                      builder: (context, state) {
                        final roles = InvitationCubit.get(context).roles;
                        final isLoading = state is RolesLoading;
                        final hasError = state is RolesFailure;
                        final hasNoRoles = roles.isEmpty && !isLoading;

                        RoleModel? dropdownValue;
                        if (_selectedRole != null) {
                          final match = roles
                              .where((r) => r.id == _selectedRole!.id)
                              .toList();
                          if (match.isNotEmpty) {
                            dropdownValue = match.first;
                          }
                        }

                        return SizedBox(
                          width: 349.w,
                          height: 56.h,
                          child: DropdownButtonFormField<RoleModel>(
                            value: dropdownValue,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF6FAFD),
                              hintText: isLoading
                                  ? 'Loading roles...'
                                  : hasError
                                  ? 'Failed to load roles'
                                  : hasNoRoles
                                  ? 'No roles available'
                                  : 'Select a role',
                              hintStyle: AppTextStyle.setpoppinsTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFEAEEF4),
                                ),
                              ),
                            ),
                            items: roles.map((role) {
                              return DropdownMenuItem<RoleModel>(
                                value: role,
                                child: Text(role.name),
                              );
                            }).toList(),
                            onChanged: isLoading || hasError || hasNoRoles
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  },
                            validator: (v) =>
                                v == null ? 'Select a role' : null,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 32.h),

                    /// Update Button with BlocConsumer for loading & feedback
                    BlocConsumer<GetAllUserCubit, GetAllUserState>(
                      listener: (context, state) {
                        if (state is UserUpdateSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context, true);
                        } else if (state is UserUpdateFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is UserUpdateLoading;
                        return CustomButton(
                          text: 'Update User',
                          width: 348.w,
                          height: 50.h,
                          isLoading: isLoading,
                          onPressed: _submitUpdate,
                          backgroundColor: const Color(0xFF1570EF),
                          textColor: Colors.white,
                          borderRadius: 8.r,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
