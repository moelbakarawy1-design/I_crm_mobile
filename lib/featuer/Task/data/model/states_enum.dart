enum TaskStatus {
  IN_PROGRESS,
  COMPLETED,
  OVERDUE,
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.IN_PROGRESS:
        return 'In Progress';
      case TaskStatus.COMPLETED:
        return 'Completed';
      case TaskStatus.OVERDUE:
        return 'Overdue';
    }
  }

  String get value {
    switch (this) {
      case TaskStatus.IN_PROGRESS:
        return 'IN_PROGRESS';
      case TaskStatus.COMPLETED:
        return 'COMPLETED';
      case TaskStatus.OVERDUE:
        return 'OVERDUE';
    }
  }

  static TaskStatus fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'COMPLETED':
        return TaskStatus.COMPLETED;
      case 'OVERDUE':
        return TaskStatus.OVERDUE;
      case 'IN_PROGRESS':
      default:
        return TaskStatus.IN_PROGRESS;
    }
  }
}
