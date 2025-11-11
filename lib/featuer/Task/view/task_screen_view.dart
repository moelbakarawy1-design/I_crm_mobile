import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart' as TaskModel;
import 'package:admin_app/featuer/Task/data/model/states_enum.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/Task/manager/task_state.dart';
import 'package:admin_app/featuer/Task/view/screen/utils/helper_Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/Task/view/widget/search_add_task_bar.dart';



class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().fetchTasks();
  }

  void _showViewTaskDialog(BuildContext context, TaskModel.TaskSummary task) {
    
    Navigator.pushNamed(
      context,
      Routes.viewTaskDialog,
      arguments: task, 
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel.TaskSummary task) {
    Navigator.pushNamed(
      context,
      Routes.editTaskDialog,
      arguments: task, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F1F3),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=>context.read<TaskCubit>().fetchTasks(), icon: Icon(Icons.refresh_rounded))
        ],
        backgroundColor: AppColor.mainWhite,
        leading: IconButton(icon: Icon(Icons.menu) , onPressed: () => Navigator.pop(context), color: AppColor.secondaryBlack),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SearchAddTaskBar(
              controller: TextEditingController(),
              onAddPressed: () =>
                  Navigator.pushNamed(context, Routes.addTaskDialog),
              onFilterPressed: () {},
              onSearchChanged: (query) {},
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // ✅ --- Added BlocListener to refresh list on success ---
              child: BlocListener<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is CreateTaskSuccess ||
                      state is UpdateTaskSuccess ||
                      state is DeleteTaskSuccess) {
                    // Show a success message
                    String message = "Success!";
                    if (state is CreateTaskSuccess) message = state.message;
                    if (state is UpdateTaskSuccess) message = state.message;
                    if (state is DeleteTaskSuccess) message = state.message;
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message), backgroundColor: Colors.green),
                    );
                    // Refresh the task list
                    context.read<TaskCubit>().fetchTasks();
                  } else if (state is DeleteTaskFailure || state is UpdateTaskFailure) {
                    // Show error message
                    String message = "An error occurred.";
                    if (state is DeleteTaskFailure) message = state.message;
                    if (state is UpdateTaskFailure) message = state.message;
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message), backgroundColor: Colors.red),
                    );
                  }
                },
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is GetAllTasksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetAllTasksError) {
                      return Center(
                        child: SizedBox.shrink()
                      );
                    }
                    if (state is GetAllTasksSuccess) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text('No tasks found.'));
                      }
                      return buildTasksContainer(state.tasks.cast<TaskModel.TaskSummary>());
                    }
                    return const Center(child: Text('Loading Tasks...'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTasksContainer(List<TaskSummary> tasks) {
    return Container(
      width: 425.w,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          buildTasksHeader(),
          const Divider(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFE0E0E0),
                thickness: 1,
                height: 10,
                indent: 8,
                endIndent: 8,
              ),
              itemBuilder: (context, index) {
                final task = tasks[index];
                String formattedDate =
                    formatTaskDate(task.startDate, task.endDate);
                Map<String, dynamic> statusInfo = _getStatusInfo(task.status);
                return buildTaskItem(
                  task: task, 
                  icon: statusInfo['icon'],
                  iconColor: statusInfo['color'],
                  date: formattedDate,
                  title: task.title ?? 'No Title',
                  status: task.status ?? 'Unknown',
                  statusColor: statusInfo['color'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

 
  Widget buildTaskItem({
  required TaskSummary task,
  required IconData icon,
  required Color iconColor,
  required String date,
  required String title,
  required String status,
  required Color statusColor,
}) {
  final currentStatus = TaskStatusExtension.fromValue(task.status ?? 'IN_PROGRESS');

  return InkWell(
    onTap: () => _showViewTaskDialog(context, task), // 👈 Navigate to view details
    borderRadius: BorderRadius.circular(8),
    splashColor: AppColor.mainBlue.withOpacity(0.1),
    child: Padding(
      padding: const EdgeInsets.all( 16.0),
      child: Row(
        children: [
          //  Date
          Expanded(
            flex: 2,
            child: Text(
              date,
              textAlign: TextAlign.start,
              style: AppTextStyle.setpoppinsTextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w400,
                color: statusColor,
              ),
            ),
          ),

          //  Title
          Expanded(
            flex: 4,
            child: Text(
              title,
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
                      color: _getStatusInfo(status.value)['color'],
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

          //  Edit Button
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _showEditTaskDialog(context, task),
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



  String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('MMM dd');
      return formatter.format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }

  String formatTaskDate(String? start, String? end) {
    final String startDate = formatDateString(start);
    final String endDate = formatDateString(end);
    return '$startDate to $endDate';
  }

  Map<String, dynamic> _getStatusInfo(String? status) {
  status = status?.toUpperCase();

  if (status == 'IN_PROGRESS') {
    return {'icon': Icons.hourglass_empty, 'color': Colors.orange};
  } else if (status == 'COMPLETED') {
    return {'icon': Icons.check_circle_outline, 'color': Colors.green};
  } else {
    return {'icon': Icons.info_outline, 'color': Colors.grey};
  }
}

}