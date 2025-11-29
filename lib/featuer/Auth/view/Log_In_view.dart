import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/utils/App_assets_utils.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      AuthCubit.get(context).login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return BlocConsumer<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state is LoginSuccess) {
        Navigator.pushNamed(context, Routes.home);
      } else if (state is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    builder: (context, state) {
      final isLoading = state is LoginLoading;

      return Scaffold(
        backgroundColor: const Color(0xFF0E87F8),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: SizedBox.expand(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 8.h,
                      left: 25.w,
                      child: Opacity(
                        opacity: 1,
                        child: SvgPicture.asset(
                          AppAssetsUtils.personalemail,
                          width: 327.w,
                          height: 256.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                height: 716.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.mainWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
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
                          'Sign in',
                          style: AppTextStyle.setpoppinsBlack(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Create an account, it is free',
                          style: AppTextStyle.setpoppinsBlack(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'Email',
                          style: AppTextStyle.setpoppinsBlack(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: FieldValidator.email,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Password',
                          style: AppTextStyle.setpoppinsBlack(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          controller: _passwordController,
                          hintText: 'Enter Your Password',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() =>
                                  _obscurePassword = !_obscurePassword);
                            },
                            icon: _obscurePassword
                                ? SvgPicture.asset(
                                    'assets/svg/eye-slash.svg',
                                    width: 20.w,
                                    height: 20.h,
                                    color: const Color(0xFF9E9E9E),
                                  )
                                : SvgPicture.asset(
                                    'assets/svg/eye_open.svg',
                                    width: 20.w,
                                    height: 20.h,
                                    color: const Color(0xFF9E9E9E),
                                  ),
                          ),
                          validator: FieldValidator.password,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 16.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.forgetPassword);
                            },
                            child: Text(
                              'Forgot password',
                              style: AppTextStyle.setpoppinsSecondaryBlack(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        /// 🔹 Show loading on button when logging in
                        CustomButton(
                          text: isLoading ? '' : 'Sign in',
                          onPressed: isLoading ? null : _handleLogin,
                          width: double.infinity,
                          backgroundColor: const Color(0xFF1A1A1A),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                        ),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: TextButton(onPressed: (){
                            Navigator.pushNamed(context, Routes.notAdminView);
                          }, child: Text('Not Admin',style: AppTextStyle.setpoppinsBlack(fontSize: 12, fontWeight: FontWeight.w400, ))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}