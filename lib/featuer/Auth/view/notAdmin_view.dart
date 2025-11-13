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

class NotAdminView extends StatefulWidget {
  const NotAdminView({super.key});

  @override
  State<NotAdminView> createState() => _NotAdminViewState();
}

class _NotAdminViewState extends State<NotAdminView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
     context.read<AuthCubit>().notAdminLogIn(email);
    }
  }
@override
Widget build(BuildContext context) {
  return BlocConsumer<AuthCubit, AuthState>(
   listener: (context, state) {
  if (state is NotAdminLogInSuccess) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message.isNotEmpty
            ? state.message
            : 'Reset email link has been sent!'),
        backgroundColor: Colors.green,
      ),
    );
  } else if (state is NotAdminLogInError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
        backgroundColor: Colors.red,
      ),
    );
  }
},

    builder: (context, state) {
final isLoading = state is NotAdminLogInLoading;
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
                          'Sign In',
                          style: AppTextStyle.setpoppinsBlack(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Please enter your email',
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
                       
                        
                        SizedBox(height: 24.h),

                        // Show loading on button when logging in
                       CustomButton(
                           text: isLoading ? '' : 'Confirmation',
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
                          child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text('go back',style: AppTextStyle.setpoppinsSecondlightGrey(fontSize: 12, fontWeight: FontWeight.w500),)),
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