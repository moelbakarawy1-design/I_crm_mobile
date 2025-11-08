import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAddTaskBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddPressed;
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;

  const SearchAddTaskBar({
    super.key,
    required this.controller,
    required this.onAddPressed,
    this.onFilterPressed,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 90.h,
      decoration: const BoxDecoration(
        color: AppColor.mainWhite,
      ),
      child: Row(
        children: [     
          Expanded(
            child: CustomTextFormField(            
              controller: controller,
              hintText: "Search Name",
              onChanged: onSearchChanged,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.search, color: Colors.grey, size: 18),
              ),
              suffixIcon:SvgPicture.asset('assets/svg/filter-add.svg' , width: 14.w,height: 14.h,fit: BoxFit.scaleDown,)
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Tasks",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
            ),
          ),
        ],
      ),
    );
  }
}
