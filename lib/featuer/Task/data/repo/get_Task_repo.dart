// 📦 Import required files
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/featuer/Task/data/model/getAllTask_model.dart'; // For task list (summary)

// 1️⃣ Define the interface
abstract class BaseTasksRepository {
  Future<List<TaskSummary>> getAllTasks();
  Future<TaskDetail> getTaskDetails(String taskId);
  Future<String> createTask({
    required String title,
    required String description,
    required List<String> assignedTo,
    required String endDate,
  });
  Future<String> updateTask({
    required String taskId,
    required Map<String, dynamic> data,
  });
  Future<String> deleteTask(String taskId);
Future<String> updateTaskStatus({
    required String taskId,
    required String newStatus,
  });}

// 2️⃣ Implementation
class TasksRepository implements BaseTasksRepository {
  final APIHelper _apiHelper;

  TasksRepository(this._apiHelper);

  // 🔹 Get all tasks
  @override
  Future<List<TaskSummary>> getAllTasks() async {
    try {
      final ApiResponse response = await _apiHelper.getRequest(
        endPoint: EndPoints.getAllTask,
        isProtected: true,
      );

      if (response.status == true && response.data != null) {
        final GetAllTaskModel model = GetAllTaskModel.fromJson(response.data);
        return model.data ?? [];
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception('Failed to load tasks: ${e.toString()}');
    }
  }

  // 🔹 Get task details by ID
  @override
  Future<TaskDetail> getTaskDetails(String taskId) async {
    try {
      final ApiResponse response = await _apiHelper.getRequest(
        endPoint: '${EndPoints.getAllTask}/$taskId',
        isProtected: true,
      );

      if (response.status == true && response.data != null) {
        final TaskDetail task = TaskDetail.fromJson(response.data);
        return task;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception('Failed to load task details: ${e.toString()}');
    }
  }

  // 🔹 Create a new task
  @override
  Future<String> createTask({
    required String title,
    required String description,
    required List<String> assignedTo,
    required String endDate,
  }) async {
    print('--- 🚀 TasksRepository: Attempting to create task ---');
    final Map<String, dynamic> taskData = {
      "title": title,
      "description": description,
      "assignedTo": assignedTo,
      "endDate": endDate,
    };
    print('📦 Sending Data: $taskData');

    try {
      final ApiResponse response = await _apiHelper.postRequest(
        endPoint: EndPoints.createTask,
        isFormData: false,
        data: taskData,
      );

      print('✅ Server Response: ${response.message}');
      if (response.status == true) {
        return response.message;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('--- ❌ Error creating task: ${e.toString()}');
      throw Exception('Error creating task: ${e.toString()}');
    }
  }

  // 🔹 Update task (PATCH)
  @override
  Future<String> updateTask({
    required String taskId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final ApiResponse response = await _apiHelper.patchRequest(
        endPoint: '${EndPoints.getAllTask}/$taskId',
        data: data,
        isFormData: false
      );
print('PATCH 📤 Sending data: $data');
      if (response.status == true) {
        print('📥 Response: ${response.statusCode} - ${response.data}');
        return response.message;
      } else {
        throw Exception(response.message);
        
      }
      
    } catch (e) {
      
      throw Exception('Error updating task: ${e.toString()}');
    }
  }

  // 🔹 Delete a task
  @override
  Future<String> deleteTask(String taskId) async {
    try {
      final ApiResponse response = await _apiHelper.deleteRequest(
        endPoint: '${EndPoints.getAllTask}/$taskId',
      );

      if (response.status == true) {
        return response.message;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception('Error deleting task: ${e.toString()}');
    }
  }
  // 🔹 Update Task Status
Future<String> updateTaskStatus({
  required String taskId,
  required String newStatus,
}) async {
  try {
    final ApiResponse response = await _apiHelper.patchRequest(
      endPoint: '${EndPoints.getAllTask}/status/$taskId',
      data: {"status": newStatus},
      isFormData: false,
    );

    print('📤 PATCH (status) data: {"status": $newStatus}');
    print('📥 Response: ${response.statusCode} - ${response.message}');

    if (response.status == true) {
      return response.message;
    } else {
      throw Exception(response.message);
    }
  } catch (e) {
    throw Exception('Error updating task status: ${e.toString()}');
  }
}

}
