// --- MODEL 1: For the list of all tasks ---

class GetAllTaskModel {
  bool? success;
  String? message;
  List<TaskSummary>? data;

  GetAllTaskModel({this.success, this.message, this.data});

  GetAllTaskModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskSummary>[];
      json['data'].forEach((v) {
        data!.add(TaskSummary.fromJson(v));
      });
    }
  }
}

class TaskSummary {
  String? id;
  String? title;
  String? status;
  String? startDate;
  String? endDate;
  String? description;
  List<AssignedTo>? assignedTo; 

  TaskSummary({
    this.id,
    this.title,
    this.status,
    this.startDate,
    this.endDate,
    this.description,
    this.assignedTo,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) {
    var assignedToList = <AssignedTo>[];
    if (json['assignedTo'] != null) {
      json['assignedTo'].forEach((v) {
        assignedToList.add(AssignedTo.fromJson(v));
      });
    }

    return TaskSummary(
      id: json['id'] ?? json['_id'],
      title: json['title'],
      status: json['status'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      description: json['description'],
      assignedTo: assignedToList,
    );
  }
}

// MODEL 2: For the single task details ---

class GetTaskIdModel {
  bool? success;
  String? message;
  TaskDetail? data;

  GetTaskIdModel({this.success, this.message, this.data});

  factory GetTaskIdModel.fromJson(Map<String, dynamic> json) {
    return GetTaskIdModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? TaskDetail.fromJson(json['data']) : null,
    );
  }
}

class TaskDetail {
  String? id;
  String? title;
  String? description; // <-- The missing field
  String? endDate;
  List<AssignedTo>? assignedTo;

  TaskDetail(
      {this.id,
      this.title,
      this.description,
      this.endDate,
      this.assignedTo});

  factory TaskDetail.fromJson(Map<String, dynamic> json) {
    var assignedToList = <AssignedTo>[];
    if (json['assignedTo'] != null) {
      json['assignedTo'].forEach((v) {
        assignedToList.add(AssignedTo.fromJson(v));
      });
    }
    
    return TaskDetail(
      id: json['id'] ?? json['_id'],
      title: json['title'],
      description: json['description'],
      endDate: json['endDate'],
      assignedTo: assignedToList,
    );
  }
}

// --- SHARED CLASS: The User info ---

class AssignedTo {
  // ✅ --- CRITICAL FIX: Added 'id' ---
  // The backend MUST send this for the Edit screen to work
  String? id; 
  String? name;
  String? email;

  AssignedTo({this.id, this.name, this.email});

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['id'] ?? json['_id'], // Reads 'id' or '_id'
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}