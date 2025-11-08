
// class GettaskIdmodel {
//   bool? success;
//   String? message;
//   TaskDetail? data;

//   GettaskIdmodel({this.success, this.message, this.data});

//   GettaskIdmodel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ?  TaskDetail.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class TaskDetail {
//   String? id;
//   String? title;
//   String? description;
//   String? endDate;
//   List<AssignedTo>? assignedTo;

//   TaskDetail({this.id, this.title, this.description, this.endDate, this.assignedTo});

//   TaskDetail.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     description = json['description'];
//     endDate = json['endDate'];
//     if (json['assignedTo'] != null) {
//       assignedTo = <AssignedTo>[];
//       json['assignedTo'].forEach((v) {
//         assignedTo!.add( AssignedTo.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['description'] = description;
//     data['endDate'] = endDate;
//     if (assignedTo != null) {
//       data['assignedTo'] = assignedTo!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class AssignedTo {
//   String? name;
//   String? email;

//   AssignedTo({this.name, this.email});

//   AssignedTo.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['email'] = email;
//     return data;
//   }
// }