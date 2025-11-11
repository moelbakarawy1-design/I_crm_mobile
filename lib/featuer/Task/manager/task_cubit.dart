
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:admin_app/featuer/Task/data/repo/get_Task_repo.dart';
import 'package:admin_app/featuer/Task/manager/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  final BaseTasksRepository _tasksRepository;

  TaskCubit(this._tasksRepository) : super(GetAllTasksInitial());

  // 🔹 Fetch all tasks
  Future<void> fetchTasks() async {
    try {
      emit(GetAllTasksLoading());
      final List<TaskSummary> tasks = await _tasksRepository.getAllTasks();
      emit(GetAllTasksSuccess(tasks));
    } catch (e) {
      emit(GetAllTasksError(e.toString()));
    }
  }

  // 🔹 Create a new task
  Future<void> createTask({
    required String title,
    required String description,
    required List<String> assignedTo,
    required DateTime endDate,
  }) async {
    print('--- 🚀 TaskCubit: createTask called ---');
    print('Title: $title');
    print('Description: $description');
    print('AssignedTo: $assignedTo');
    print('EndDate (DateTime): $endDate');
    print('EndDate (ISO String): ${endDate.toIso8601String()}');

    try {
      emit(CreateTaskLoading());
      final String message = await _tasksRepository.createTask(
        title: title,
        description: description,
        assignedTo: assignedTo,
        endDate: endDate.toIso8601String(),
      );

      print('✅ TaskCubit: Task created successfully. Message: $message');
      emit(CreateTaskSuccess(message));
    } catch (e) {
      print('--- ❌ TaskCubit Error ---');
      print('Error in createTask: ${e.toString()}');
      print('---------------------------');
      emit(CreateTaskFailure(e.toString()));
    }
  }

  // 🔹 Get a specific task by ID
  Future<void> getTaskDetails(String taskId) async {
    try {
      emit(GetTaskDetailsLoading());
      final TaskDetail task = await _tasksRepository.getTaskDetails(taskId);
      emit(GetTaskDetailsSuccess(task));
    } catch (e) {
      emit(GetTaskDetailsFailure(e.toString()));
    }
  }

  // 🔹 Update an existing task
  Future<void> updateTask({
    required String taskId,
    String? title,
    String? description,
    List<String>? assignedTo,
    DateTime? endDate,
    String? status
  }) async {
    try {
      emit(UpdateTaskLoading());

      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (assignedTo != null) data['assignedTo'] = assignedTo;
      if (endDate != null) data['endDate'] = endDate.toIso8601String();
      if (status != null) data['status'] = status;

      final String message = await _tasksRepository.updateTask(
        taskId: taskId,
        data: data,
      );

      emit(UpdateTaskSuccess(message));
    } catch (e) {
      emit(UpdateTaskFailure(e.toString()));
    }
  }

  // 🔹 Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      emit(DeleteTaskLoading());
      final String message = await _tasksRepository.deleteTask(taskId);
      emit(DeleteTaskSuccess(message));
    } catch (e) {
      emit(DeleteTaskFailure(e.toString()));
    }
  }
  // 🔹 Update only the task status
Future<void> updateTaskStatus(String taskId, String newStatus) async {
  try {
    emit(UpdateTaskStatusLoading());
    final String message = await _tasksRepository.updateTaskStatus(
      taskId: taskId,
      newStatus: newStatus,
    );
    emit(UpdateTaskStatusSuccess(message));
  } catch (e) {
    emit(UpdateTaskStatusFailure(e.toString()));
  }
}

}
