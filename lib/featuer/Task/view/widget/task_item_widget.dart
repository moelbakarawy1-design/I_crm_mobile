import 'package:admin_app/featuer/Task/view/utils/task_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart' as TaskModel;
import 'package:admin_app/featuer/Task/data/model/states_enum.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel.TaskSummary task;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> statusInfo = TaskHelper.getStatusInfo(task.status);
    final String formattedDate = TaskHelper.formatTaskDate(task.startDate, task.endDate);
    final currentStatus = TaskStatusExtension.fromValue(task.status ?? 'IN_PROGRESS');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: AppColor.mainBlue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Date
            Expanded(
              flex: 2,
              child: Text(
                formattedDate,
                textAlign: TextAlign.start,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  color: statusInfo['color'],
                ),
              ),
            ),

            // Title
            Expanded(
              flex: 4,
              child: Text(
                task.title ?? 'No Title',
                textAlign: TextAlign.center,
                style: AppTextStyle.setpoppinsTextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: AppColor.mainBlack,
                ),
              ),
            ),

            // Status Dropdown
            Expanded(
              flex: 2,
              child: DropdownButton<TaskStatus>(
                value: currentStatus,
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                isDense: true,
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem<TaskStatus>(
                    value: status,
                    child: Text(
                      status.label,
                      style: AppTextStyle.setpoppinsTextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: TaskHelper.getStatusInfo(status.value)['color'],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    context.read<TaskCubit>().updateTaskStatus(
                          task.id!,
                          newStatus.value,
                        );
                  }
                },
              ),
            ),

            // Edit Button
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onEdit,
                  child: SvgPicture.asset(
                    'assets/svg/edit-2.svg',
                    width: 12.w,
                    height: 12.h,
                    color: AppColor.mainBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}