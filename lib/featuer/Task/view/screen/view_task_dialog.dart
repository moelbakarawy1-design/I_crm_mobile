import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/core/widgets/CustomAppBar_widget.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/Task/view/screen/utils/helper_Utils.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ViewTaskDialog extends StatelessWidget {
  final TaskSummary task;

  const ViewTaskDialog({super.key, required this.task});

  void _showEditTaskDialog(BuildContext context, TaskSummary task) {
    Navigator.pushNamed(
      context,
      Routes.editTaskDialog,
      arguments: task,
    );
  }

  // Helper to show Delete Confirmation
  void _showDeleteConfirmationDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Call the cubit to delete
                context.read<TaskCubit>().deleteTask(taskId);
                Navigator.pop(dialogContext); // Close confirmation
                Navigator.pop(context); // Close view dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "N/A";
    if (task.endDate != null) {
      try {
        final DateTime parsedDate = DateTime.parse(task.endDate!);
        formattedDate = DateFormat('d-M-y').format(parsedDate);
      } catch (e) {
        //
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'View Task'),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 45.h),
        child: Container(
          height: 520.h,
          width: 388.w,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('View Task',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/svg/Button.svg',
                            width: 50.w, height: 50.h))
                  ],
                ),
                SizedBox(height: 20.h),
                // Title
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAFD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(task.title ?? 'No Title',
                      style: AppTextStyle.setpoppinsSecondaryBlack(
                          fontSize: 9, fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: 15.h),
                //description
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAFD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(task.description ?? 'No Title',
                      style: const TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 15.h),
                //assignedTo
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAFD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: (task.assignedTo == null || task.assignedTo!.isEmpty)
                      ? const Text("No users assigned",
                          style: TextStyle(color: Colors.grey))
                      // Build the list of chips
                      : Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: task.assignedTo!
                              .map((user) => buildUserChip(user))
                              .toList(),
                        ),
                ),
                SizedBox(height: 15.h),
                // Date
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAFD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/calendar 1.svg'),
                      SizedBox(width: 8.w),
                      Text(formattedDate, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                FutureBuilder<List<bool>>(
                  // Check both permissions at once: [UPDATE_TASK, DELETE_TASK]
                  future: Future.wait([
                    LocalData.hasEnumPermission(Permission.UPDATE_TASK),
                    LocalData.hasEnumPermission(Permission.DELETE_TASK),
                  ]),
                  builder: (context, snapshot) {
                    // While loading, hide buttons or show loader
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final canUpdate = snapshot.data![0];
                    final canDelete = snapshot.data![1];

                    return Column(
                      children: [
                        // Edit Button (Only if UPDATE_TASK permission)
                        if (canUpdate)
                          CustomButton(
                            width: 332.w,
                            text: 'Edit Task',
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            borderRadius: 8,
                            height: 40.h,
                            onPressed: () {
                              Navigator.pop(context); // Close this view dialog
                              _showEditTaskDialog(
                                  context, task); // Open edit dialog
                            },
                          ),

                        if (canUpdate) SizedBox(height: 10.h),

                        // Delete Button (Only if DELETE_TASK permission)
                        if (canDelete)
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Delete Task',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              borderRadius: 30,
                              height: 45.h,
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, task.id!);
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}