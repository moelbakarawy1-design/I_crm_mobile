import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/widgets/custom_textField_widget.dart';
import 'package:admin_app/featuer/Task/data/model/states_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAddTaskBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAddPressed;
  final ValueChanged<TaskStatus?>? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;

  const SearchAddTaskBar({
    super.key,
    required this.controller,
    required this.onAddPressed,
    this.onFilterPressed,
    this.onSearchChanged,
  });

  @override
  State<SearchAddTaskBar> createState() => _SearchAddTaskBarState();
}

class _SearchAddTaskBarState extends State<SearchAddTaskBar> {
  TaskStatus? selectedStatus;

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
          // 🔍 Search field + Filter icon
          Expanded(
            child: CustomTextFormField(
              controller: widget.controller,
              hintText: "Search Name",
              onChanged: widget.onSearchChanged,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.search, color: Colors.grey, size: 18),
              ),
              suffixIcon: GestureDetector(
                onTapDown: (details) async {
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject() as RenderBox;

                  final result = await showMenu<TaskStatus?>(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      const PopupMenuItem(
                          value: null, child: Text('All Tasks')),
                      const PopupMenuItem(
                          value: TaskStatus.IN_PROGRESS,
                          child: Text('In Progress')),
                      const PopupMenuItem(
                          value: TaskStatus.COMPLETED,
                          child: Text('Completed')),
                      const PopupMenuItem(
                          value: TaskStatus.OVERDUE,
                          child: Text('Overdue')),
                    ],
                  );

                  if (result != null || result == null) {
                    setState(() => selectedStatus = result);
                    widget.onFilterPressed?.call(result);
                  }
                },
                child: SvgPicture.asset(
                  'assets/svg/filter-add.svg',
                  width: 14.w,
                  height: 14.h,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ➕ Add button
          ElevatedButton.icon(
            onPressed: widget.onAddPressed,
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
