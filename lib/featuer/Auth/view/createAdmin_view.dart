import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreateAdminView extends StatefulWidget {
  const CreateAdminView({super.key});

  @override
  State<CreateAdminView> createState() => _CreateAdminViewState();
}

class _CreateAdminViewState extends State<CreateAdminView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleCreateAdmin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().createAdmin(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            passwordConfirm: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E90FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: SvgPicture.asset('assets/svg/reset_Password.svg'),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.mainWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
                
                child: BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is CreateAdminSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                    if (state is CreateAdminError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 40.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Admin',
                            style: AppTextStyle.setpoppinsBlack(
                                fontSize: 32, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Enter admin details below',
                            style: AppTextStyle.setpoppinsBlack(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 32.h),

                          // Name Field
                          Text('Name',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _nameController,
                            hintText: 'Enter admin name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20.h),

                          // Email Field
                          Text('Email',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _emailController,
                            hintText: 'Enter email address',
                            keyboardType: TextInputType.emailAddress,
                            validator: FieldValidator.email,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20.h),

                          // Password Field
                          Text('Password',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _passwordController,
                            hintText: 'Enter password',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              icon: _obscurePassword
                                  ? SvgPicture.asset('assets/svg/eye-slash.svg',
                                      width: 24.w, height: 24.h)
                                  : SvgPicture.asset('assets/svg/eye_open.svg',
                                      width: 24.w, height: 24.h),
                            ),
                            validator: FieldValidator.password,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20.h),

                          // Confirm Password Field
                          Text('Confirm Password',
                              style: AppTextStyle.setpoppinsBlack(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.h),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm password',
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                              icon: _obscureConfirmPassword
                                  ? SvgPicture.asset('assets/svg/eye-slash.svg',
                                      width: 24.w, height: 24.h)
                                  : SvgPicture.asset('assets/svg/eye_open.svg',
                                      width: 24.w, height: 24.h),
                            ),
                            validator: _validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 32.h),

                          // Submit Button
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is CreateAdminLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return CustomButton(
                                text: 'Create Admin',
                                onPressed: _handleCreateAdmin,
                                width: double.infinity,
                                backgroundColor: const Color(0xFF1A1A1A),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}