import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/user_search_header.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/user_table_row.dart';
import 'package:admin_app/core/helper/enum_permission.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvitationPage extends StatefulWidget {
  const InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GetAllUserCubit>().fetchAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetAllUserCubit, GetAllUserState>(
      listener: (context, state) {
        // Show error messages in snackbar
        if (state is GetAllUserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        // Show success message when user is deleted
        else if (state is UserDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Send Invite',
          onMenuPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            UserSearchHeader(
              searchController: _searchController,
              onChanged: () {
                setState(() {}); // Trigger rebuild to filter users
              },
            ),

            FutureBuilder<bool>(
              future: LocalData.hasEnumPermission(Permission.CREATE_USER),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.addControllerPage,
                          );
                        },
                        icon: Icon(Icons.add, size: 16.w, color: Colors.white),
                        label: Text(
                          'Add Controller',
                          style: AppTextStyle.setpoppinsWhite(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            SizedBox(height: 12.h),

            // 3. Users Table Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocBuilder<GetAllUserCubit, GetAllUserState>(
                  builder: (context, state) {
                    if (state is GetAllUserLoading ||
                        state is GetAllUserInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetAllUserFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Failed to load users',
                              style: AppTextStyle.setpoppinsTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.mainBlack,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ElevatedButton.icon(
                              onPressed: () => context
                                  .read<GetAllUserCubit>()
                                  .fetchAllUsers(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is GetAllUserSuccess) {
                      final users = state.userModel.data ?? [];

                      if (users.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      // Apply local search filtering
                      final filteredUsers = _searchController.text.isEmpty
                          ? users
                          : users.where((user) {
                              final name = user.name?.toLowerCase() ?? '';
                              final email = user.email?.toLowerCase() ?? '';
                              final query = _searchController.text
                                  .toLowerCase();
                              return name.contains(query) ||
                                  email.contains(query);
                            }).toList();

                      return _buildUsersTable(filteredUsers);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTable(List<Data> users) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainBlack.withOpacity(0.05),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _tableHeader('Name')),
                  Expanded(flex: 4, child: _tableHeader('Email')),
                  Expanded(flex: 3, child: _tableHeader('Role')),
                  Expanded(flex: 3, child: _tableHeader('Actions')),
                ],
              ),
            ),
          ),

          // Table Content List
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade200, height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                return TableRowWidget(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      child: Text(
        title,
        style: AppTextStyle.setpoppinsTextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.gray70,
        ),
      ),
    );
  }
}
