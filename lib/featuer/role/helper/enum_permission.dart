// ignore_for_file: constant_identifier_names

enum Permission {
  ADMIN,
  READ_WHATSAPP,
  READ_WRITE_WHATSAPP,
  READ_ALL_CHATS,
  DELETE_CHAT,
  CREATE_ROLE,
  READ_ROLES,
  UPDATE_ROLE,
  DELETE_ROLE,
  CREATE_USER,
  READ_USERS,
  UPDATE_USER,
  DELETE_USER,
  READ_ALL_TASKS,
  CREATE_TASK,
  UPDATE_TASK,
  DELETE_TASK,
}
extension PermissionExtension on Permission {
  String get value {
    switch (this) {
      case Permission.ADMIN:
        return "ADMIN";
      case Permission.READ_WHATSAPP:
        return "READ_WHATSAPP";
      case Permission.READ_WRITE_WHATSAPP:
        return "READ_WRITE_WHATSAPP";
      case Permission.READ_ALL_CHATS:
        return "READ_ALL_CHATS";
      case Permission.DELETE_CHAT:
        return "DELETE_CHAT";
      case Permission.CREATE_ROLE:
        return "CREATE_ROLE";
      case Permission.READ_ROLES:
        return "READ_ROLES";
      case Permission.UPDATE_ROLE:
        return "UPDATE_ROLE";
      case Permission.DELETE_ROLE:
        return "DELETE_ROLE";
      case Permission.CREATE_USER:
        return "CREATE_USER";
      case Permission.READ_USERS:
        return "READ_USERS";
      case Permission.UPDATE_USER:
        return "UPDATE_USER";
      case Permission.DELETE_USER:
        return "DELETE_USER";
      case Permission.READ_ALL_TASKS:
        return "READ_ALL_TASKS";
      case Permission.CREATE_TASK:
        return "CREATE_TASK";
      case Permission.UPDATE_TASK:
        return "UPDATE_TASK";
      case Permission.DELETE_TASK:
        return "DELETE_TASK";
    }
  }

  static Permission fromString(String value) {
    return Permission.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception("Invalid permission: $value"),
    );
  }
}
