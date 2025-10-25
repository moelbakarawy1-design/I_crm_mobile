import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.leading
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColor.mainWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // #00000040
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppColor.grey),
              onPressed: onMenuPressed,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:AppTextStyle.setpoppinsTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColor.blue,)
              ),
            ),
            const SizedBox(width: 48), // keep title centered
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
