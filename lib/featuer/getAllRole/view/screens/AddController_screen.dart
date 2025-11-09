import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/getAllRole/data/model/role_model.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_cubit.dart';
import 'package:admin_app/featuer/getAllRole/manager/role_state.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/custom_textfield_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddControllerPage extends StatefulWidget {
  const AddControllerPage({super.key});

  @override
  State<AddControllerPage> createState() => _AddControllerPageState();
}

class _AddControllerPageState extends State<AddControllerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  RoleModel? _selectedRole;

  @override
  void initState() {
    super.initState();
    InvitationCubit.get(context).fetchRoles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a role'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      InvitationCubit.get(context).sendInvitation(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        roleName: _selectedRole!.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvitationCubit, InvitationState>(
      listener: (context, state) {
        if (state is InvitationSent) {
          Navigator.pop(context, {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'role': _selectedRole!.name,
            'date': DateTime.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is InvitationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25,170,25,289),
              child: Container(
                width: 388.w,
                height: 497.h,
                padding: EdgeInsets.only(left: 25.w,right: 25.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add New Controller',
                              style: AppTextStyle.setpoppinsTextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0XFF092C4C))
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset('assets/svg/Button.svg',width:50.w , height: 50.h,fit: BoxFit.scaleDown,),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                    
                        // Name
                        Text('Name',style: AppTextStyle.setpoppinsTextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0XFF667085)),),
                        SizedBox(height: 8.h),
                        CustomTextFieldAddController(
                          suffixSvgIcon:  'assets/svg/edit-2.svg',
                            controller: _nameController,
                            hintText: 'Enter name',
                            labelText: 'Name',
                            validator: (v) => v!.isEmpty ? 'Name is required' : null,
                         ),
                        SizedBox(height: 20.h),
                    
                        // Email
                        Text('Email',style: AppTextStyle.setpoppinsTextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0XFF667085)),),
                        SizedBox(height: 8.h),
                        CustomTextFieldAddController(
                           suffixSvgIcon:  'assets/svg/edit-2.svg',
                         controller: _emailController,
                         hintText: 'Enter email',
                         labelText: 'Email',
                         keyboardType: TextInputType.emailAddress,
                        //  validator:FieldValidator.email,
                       ),
                        SizedBox(height: 15.h),
                        // Role Dropdown           
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
                                buildWhen: (previous, current) =>
                                    current is RolesLoading ||
                                    current is RolesSuccess ||
                                    current is RolesFailure,
                                builder: (context, state) {
                                  final isLoading = state is RolesLoading;
                                  final roles = InvitationCubit.get(context).roles;
                                  final hasError = state is RolesFailure;
                                  final hasNoRoles = roles.isEmpty && !isLoading;
                    
                                  return SizedBox(
                                    width: 349.w,
                                    height: 56.h,
                                    child: DropdownButtonFormField<RoleModel>(
                                      value: _selectedRole,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(12.r),
                                      menuMaxHeight: 349.h,
                                      decoration: InputDecoration(
                                        filled: true,
                                        
                                        fillColor: isLoading || hasError || hasNoRoles
                                            ? const Color(0xFFF6FAFD)
                                            : const Color(0xFFF6FAFD),
                                        hintText: isLoading
                                            ? 'Loading roles...'
                                            : hasError
                                                ? 'Failed to load roles'
                                                : hasNoRoles
                                                    ? 'No roles available'
                                                    : 'Select a role',
                                        hintStyle: AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500,  color: isLoading || hasError || hasNoRoles
                                              ? Colors.grey.shade500
                                              : const Color(0xFF667085),),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 14.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFEAEEF4),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFEAEEF4),
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFEAEEF4),
                                            width: 2,
                                          ),
                                        ),
                                        suffixIcon: Container(
                                          padding: EdgeInsets.only(right: 12.w),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: isLoading || hasError || hasNoRoles
                                                ? Colors.grey.shade400
                                                : const Color(0xFF667085),
                                            size: 24.w,
                                          ),
                                        ),
                                      ),
                                      icon: const SizedBox.shrink(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0XFF092C4C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      items: roles.map((role) {
                                        return DropdownMenuItem<RoleModel>(
                                          value: role,
                                          child: Text(
                                            role.name,
                                            style: AppTextStyle.setpoppinsTextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0XFF7E92A2))
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: isLoading || hasError || hasNoRoles
                                          ? null
                                          : (value) {
                                              setState(() {
                                                _selectedRole = value;
                                              });
                                            },
                                      validator: (value) =>
                                          value == null ? 'Please select a role' : null,
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: 32.h),
                       GestureDetector(
  onTap: _handleSubmit, 
  child: Container(
    width: 348,
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFF1570EF),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(Icons.send, color: Colors.white),
        const SizedBox(width: 12),
        const Text(
          'Send',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
)

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}