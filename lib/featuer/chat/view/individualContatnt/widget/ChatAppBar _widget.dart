import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/view/widgets/Assign_user_rename_user.dart/chat_actions_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Data chatModel;

  const ChatAppBar({
    super.key,
    required this.chatModel,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: AppColor.lightBlue,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: SlideTransition(
        position: _slideAnimation,
        child: Row(
          children: [
            // Animated Avatar
            ScaleTransition(
              scale: _scaleAnimation,
              child: Hero(
                tag: 'avatar_${widget.chatModel.id}',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            
            // Animated Name
            Expanded(
              child: FadeTransition(
                opacity: _controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.chatModel.customer?.name ?? 'Chat',
                      style: AppTextStyle.setpoppinsWhite(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Optional: Online status indicator
                    Text(
                      'Online',
                      style: AppTextStyle.setpoppinsWhite(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            onPressed: () {
              ChatOptionsHelper.showOptionsSheet(
                context,
                widget.chatModel.id ?? '',
              );
            },
            icon: SvgPicture.asset(
              'assets/svg/setting-2.svg',
              width: 30.w,
              height: 30.h,
              fit: BoxFit.scaleDown,
              color: AppColor.mainWhite,
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}