import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/User/data/model/getAllUser_model.dart';
import 'package:admin_app/featuer/User/manager/user_cubit.dart';
import 'package:admin_app/featuer/User/manager/user_state.dart';
import 'package:admin_app/featuer/getAllRole/view/widget/user_table_row.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:admin_app/featuer/role/helper/Function_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send Invite',
        onMenuPressed: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Search and Add Controller Button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyle.setpoppinsTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.gray70),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEAEEF4),
                        hintText: 'Search Name',
                        hintStyle: AppTextStyle.setpoppinsTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.gray70),
                        prefixIcon: SvgPicture.asset(
                          'assets/svg/Vector.svg',
                          width: 16.w,
                          height: 16.h,
                          fit: BoxFit.scaleDown,
                          colorFilter: const ColorFilter.mode(
                              Color(0xFF9CA3AF), BlendMode.srcIn),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ),                
                FutureBuilder<bool>(
                  future: LocalData.hasEnumPermission(Permission.CREATE_USER),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == false) {
                      return const SizedBox.shrink();
                    }
                    
                    // If Permission Granted, Show Button
                    return Row(
                      children: [
                        SizedBox(width: 6.w),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.addControllerPage);
                          },
                          icon: Icon(Icons.add, size: 16.w, color: Colors.white),
                          label: Text(
                            'Add Controller',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 10.h),
                            minimumSize: Size(122.w, 38.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                IconButton(
                    onPressed: () {
                      context.read<GetAllUserCubit>().fetchAllUsers();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: AppColor.mainBlue,
                    )),
              ],
            ),
            SizedBox(height: 16.h),

            // Users Table
            Expanded(
              child: BlocBuilder<GetAllUserCubit, GetAllUserState>(
                builder: (context, state) {
                  if (state is GetAllUserLoading || state is GetAllUserInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetAllUserFailure) {
                    return Center(child: buildError("Error: ${state.message}", context));
                  } else if (state is GetAllUserSuccess) {
                    final users = state.userModel.data ?? [];

                    if (users.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    // Apply search filter
                    final filteredUsers = _searchController.text.isEmpty
                        ? users
                        : users
                            .where((user) =>
                                user.name!
                                    .toLowerCase()
                                    .contains(_searchController.text.toLowerCase()) ||
                                user.email!
                                    .toLowerCase()
                                    .contains(_searchController.text.toLowerCase()))
                            .toList();

                    return _buildUsersTable(filteredUsers);
                  }

                  return const SizedBox();
                },
              ),
            ),
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

          // Table Content
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
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