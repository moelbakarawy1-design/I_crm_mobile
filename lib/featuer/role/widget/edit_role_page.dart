import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditRolePage extends StatefulWidget {
  final RoleModel role;
  const EditRolePage({super.key, required this.role});

  @override
  State<EditRolePage> createState() => _EditRolePageState();
}

class _EditRolePageState extends State<EditRolePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  late List<String> _availablePermissions;
  final Set<String> _selectedPermissions = {};


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role.name);

    _availablePermissions = context.read<InvitationCubit>().allUniquePermissions;
    _selectedPermissions.addAll(widget.role.permissions ?? []);
   
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPermissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one permission'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // ---

    final name = _nameController.text;

    context.read<InvitationCubit>().updateRole(
          roleId: widget.role.id, // Pass the role ID
          name: name,
          permissions: _selectedPermissions.toList(), // Use the Set
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColor.primaryWhite,
        centerTitle: true,
        title: Text('Edit ${widget.role.name}',style: AppTextStyle.setpoppinsBlack(fontSize: 15, fontWeight: FontWeight.w500),)),
      body: BlocListener<InvitationCubit, InvitationState>(
        listener: (context, state) {
          if (state is UpdateRoleSuccess) {
            Navigator.pop(context); // Go back to roles list
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Role updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is UpdateRoleFailure) {
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

              // --- IMPROVED: Replaced permissions text field with Checkboxes ---
              ..._availablePermissions.map((permission) {
                return CheckboxListTile(
                  title: Text(
                    permission,
                    style: AppTextStyle.setpoppinsBlack(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  value: _selectedPermissions.contains(permission),
                  activeColor: AppColor.blue,
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
                    backgroundColor: AppColor.blue,
                    text: 'Save Changes',
                    onPressed: _submit,
                    isLoading: state is UpdateRoleLoading,
                    width: double.infinity,
                    height: 45.h,
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