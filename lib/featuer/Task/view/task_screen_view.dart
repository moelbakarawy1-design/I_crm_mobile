import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Task/data/model/states_enum.dart';
import 'package:admin_app/core/helper/enum_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/config/router/routes.dart';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/Task/manager/task_cubit.dart';
import 'package:admin_app/featuer/Task/manager/task_state.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart' as TaskModel;
import 'package:admin_app/featuer/Task/view/widget/search_add_task_bar.dart';
import 'package:admin_app/featuer/Task/view/widget/task_list_container.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F1F3),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.read<TaskCubit>().fetchTasks(),
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
        backgroundColor: AppColor.mainWhite,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.pop(context),
          color: AppColor.secondaryBlack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder<bool>(
              future: LocalData.hasEnumPermission(Permission.CREATE_TASK),
              builder: (context, snapshot) {
                final bool canCreateTask = snapshot.data ?? false;
                return SearchAddTaskBar(
                  controller: TextEditingController(),           
                  onAddPressed: canCreateTask 
                      ? () => Navigator.pushNamed(context, Routes.addTaskDialog)
                      : null, 
                  
                  onFilterPressed: (status) {
                    context.read<TaskCubit>().filterTasksByStatus(status?.value);
                  },
                  onSearchChanged: (query) {
                    context.read<TaskCubit>().searchTasksByName(query);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Lower Part: Task List
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocListener<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is CreateTaskSuccess ||
                      state is UpdateTaskSuccess ||
                      state is DeleteTaskSuccess) {
                    String message = "Success!";
                    if (state is CreateTaskSuccess) message = state.message;
                    if (state is UpdateTaskSuccess) message = state.message;
                    if (state is DeleteTaskSuccess) message = state.message;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message), backgroundColor: Colors.green),
                    );

                    // Refresh data
                    context.read<TaskCubit>().fetchTasks();
                  } else if (state is DeleteTaskFailure ||
                      state is UpdateTaskFailure) {
                    String message = "An error occurred.";
                    if (state is DeleteTaskFailure) message = state.message;
                    if (state is UpdateTaskFailure) message = state.message;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message), backgroundColor: Colors.red),
                    );
                  }
                },
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is GetAllTasksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetAllTasksError) {
                      return const Center(child: SizedBox.shrink());
                    }
                    if (state is GetAllTasksSuccess) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text('No tasks found.'));
                      }
                      return TaskListContainer(
                          tasks: state.tasks.cast<TaskModel.TaskSummary>());
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
}