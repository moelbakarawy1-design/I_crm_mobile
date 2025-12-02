import 'dart:async';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/home/view/pages/widget/profile_account_info.dart';
import 'package:admin_app/featuer/home/view/pages/widget/profile_error_state.dart';
import 'package:admin_app/featuer/home/view/pages/widget/profile_header_card.dart';
import 'package:admin_app/featuer/home/view/pages/widget/profile_permissions_section.dart';
import 'package:admin_app/featuer/home/view/pages/widget/profile_quick_stats.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_cubit.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  StreamSubscription<dynamic>? _roleUpdateSubscription;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserProfile();
    _initAnimations();
    _listenToRoleUpdates();
  }

  void _listenToRoleUpdates() {
    // Listen for role updates from socket
    final socketService = SocketService();
    _roleUpdateSubscription = socketService.roleUpdatedStream.listen((data) {
      print('👑 [ProfilePage] Role updated, refreshing profile...');
      // Refresh the profile to show new role
      if (mounted) {
        context.read<AuthCubit>().getUserProfile();
      }
    });
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _roleUpdateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        onMenuPressed: () => Navigator.pop(context),
      ),
      backgroundColor: AppColor.primaryWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            // Handle navigation
          }
        },
        buildWhen: (previous, current) =>
            current is GetProfileLoading ||
            current is GetProfileSuccess ||
            current is GetProfileError,
        builder: (context, state) {
          if (state is GetProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.mainBlue),
            );
          } else if (state is GetProfileError) {
            return ProfileErrorState(
              message: state.message,
              onRetry: () => context.read<AuthCubit>().getUserProfile(),
            );
          } else if (state is GetProfileSuccess) {
            return _buildProfileContent(state.user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(Data user) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    children: [
                      ProfileHeaderCard(user: user),
                      SizedBox(height: 20.h),
                      ProfileQuickStats(user: user),
                      SizedBox(height: 20.h),
                      ProfileAccountInfo(user: user),
                      SizedBox(height: 20.h),
                      if (user.role?.permissions != null && 
                          user.role!.permissions!.isNotEmpty)
                        ProfilePermissionsSection(user: user),
                      SizedBox(height: 24.h),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}