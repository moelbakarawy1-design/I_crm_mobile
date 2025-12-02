import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserErrorView extends StatelessWidget {
  final String message;

  const UserErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColor.lightBlue),
          const SizedBox(height: 16),
          Text(
            'Error Loading Users',
            style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.secondaryBlack),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 48),
              backgroundColor: AppColor.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => context.read<GetAllUserCubit>().fetchAllUsers(),
            child: Text(
              'Retry',
              style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 16,
                  color: AppColor.mainWhite,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}