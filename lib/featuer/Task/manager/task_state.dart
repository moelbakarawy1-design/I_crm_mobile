
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart';
import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

// --- Get All Tasks ---
class GetAllTasksInitial extends TaskState {}

class GetAllTasksLoading extends TaskState {}

class GetAllTasksSuccess extends TaskState {
  final List<TaskSummary> tasks;
  const GetAllTasksSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class GetAllTasksError extends TaskState {
  final String errorMessage;
  const GetAllTasksError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// --- Create Task ---
class CreateTaskLoading extends TaskState {}

class CreateTaskSuccess extends TaskState {
  final String message;
  const CreateTaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateTaskFailure extends TaskState {
  final String message;
  const CreateTaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Get Task Details ---
class GetTaskDetailsLoading extends TaskState {}

class GetTaskDetailsSuccess extends TaskState {
  final TaskDetail task; // ✅ Correct class name
  const GetTaskDetailsSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class GetTaskDetailsFailure extends TaskState {
  final String message;
  const GetTaskDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Update Task ---
class UpdateTaskLoading extends TaskState {}

class UpdateTaskSuccess extends TaskState {
  final String message;
  const UpdateTaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateTaskFailure extends TaskState {
  final String message;
  const UpdateTaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Delete Task ---
class DeleteTaskLoading extends TaskState {}

class DeleteTaskSuccess extends TaskState {
  final String message;
  const DeleteTaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteTaskFailure extends TaskState {
  final String message;
  const DeleteTaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}
// --- Update Task Status ---
class UpdateTaskStatusLoading extends TaskState {}

class UpdateTaskStatusSuccess extends TaskState {
  final String message;
  const UpdateTaskStatusSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateTaskStatusFailure extends TaskState {
  final String message;
  const UpdateTaskStatusFailure(this.message);

  @override
  List<Object?> get props => [message];
}

