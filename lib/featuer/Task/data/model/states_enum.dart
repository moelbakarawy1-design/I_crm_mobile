enum TaskStatus {
  IN_PROGRESS,
  COMPLETED,
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.IN_PROGRESS:
        return 'In Progress';
      case TaskStatus.COMPLETED:
        return 'Completed';
      
    }
  }

  String get value {
    switch (this) {
      case TaskStatus.IN_PROGRESS:
        return 'IN_PROGRESS';
      case TaskStatus.COMPLETED:
        return 'COMPLETED';
    }
  }

  static TaskStatus fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'COMPLETED':
        return TaskStatus.COMPLETED;
      case 'IN_PROGRESS':
      default:
        return TaskStatus.IN_PROGRESS;
    }
  }
}
