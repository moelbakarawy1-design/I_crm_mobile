// ignore_for_file: constant_identifier_names

enum Permission {
  READ_WHATSAPP,
  READ_WRITE_WHATSAPP,
  READ_ALL_CHATS,
  DELETE_CHAT,
  READ_USERS,
  CREATE_USER,
  UPDATE_USER,
  DELETE_USER,
  READ_ROLES,
  CREATE_ROLE,
  UPDATE_ROLE,
  DELETE_ROLE,
  READ_ALL_TASKS,
  CREATE_TASK,
  UPDATE_TASK,
  DELETE_TASK,
  ASSIGN_CHAT,
  UNKNOWN,
}

extension PermissionExtension on Permission {
  String get value => name;

  static Permission fromString(String value) {
    try {
      return Permission.values.firstWhere((e) => e.name == value);
    } catch (e) {
      return Permission.UNKNOWN;
    }
  }
}