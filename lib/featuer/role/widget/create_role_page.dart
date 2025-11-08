import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:admin_app/featuer/role/helper/enum_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // ✅ Use enum instead of strings
  final Set<Permission> _selectedPermissions = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPermissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one permission'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final name = _nameController.text;
    final permissionStrings =
        _selectedPermissions.map((p) => p.value).toList(); // ✅ Convert enum → string

    context.read<InvitationCubit>().createRole(
          name: name,
          permissions: permissionStrings,
        );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Get all permissions from enum instead of Cubit
    final allPermissions = Permission.values;

    return Scaffold(
      backgroundColor: AppColor.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColor.primaryWhite,
        centerTitle: true,
        title: Text(
          'Create New Role',
          style: AppTextStyle.setpoppinsBlack(
              fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocListener<InvitationCubit, InvitationState>(
        listener: (context, state) {
          if (state is CreateRoleSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Role created successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is CreateRoleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              CustomTextFormField(
                controller: _nameController,
                labelText: 'Role Name',
                hintText: 'Enter the role name',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Name is required' : null,
              ),
              SizedBox(height: 24.h),

              Text(
                'Permissions',
                style: AppTextStyle.setpoppinsBlack(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),

              // ✅ Build list of checkboxes from enum
              ...allPermissions.map((permission) {
                return CheckboxListTile(
                  title: Text(
                    permission.value,
                    style: AppTextStyle.setpoppinsBlack(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  value: _selectedPermissions.contains(permission),
                  activeColor: AppColor.lightBlue,
                  onChanged: (bool? isSelected) {
                    setState(() {
                      if (isSelected == true) {
                        _selectedPermissions.add(permission);
                      } else {
                        _selectedPermissions.remove(permission);
                      }
                    });
                  },
                );
              }),

              SizedBox(height: 32.h),
              BlocBuilder<InvitationCubit, InvitationState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Create Role',
                    onPressed: _submit,
                    isLoading: state is CreateRoleLoading,
                    width: double.infinity,
                    height: 50.h,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
