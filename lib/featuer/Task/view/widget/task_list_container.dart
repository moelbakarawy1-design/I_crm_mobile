import 'package:admin_app/featuer/Task/view/screen/utils/helper_Utils.dart';
import 'package:admin_app/featuer/Task/view/widget/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart' as TaskModel;
import 'package:admin_app/config/router/routes.dart';

class TaskListContainer extends StatelessWidget {
  final List<TaskModel.TaskSummary> tasks;

  const TaskListContainer({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
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
                return TaskItemWidget(
                  task: task,
                  onTap: () {
                     Navigator.pushNamed(
                      context,
                      Routes.viewTaskDialog,
                      arguments: task,
                    );
                  },
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      Routes.editTaskDialog,
                      arguments: task,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}