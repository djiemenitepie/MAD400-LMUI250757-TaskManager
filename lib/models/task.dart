// Task model class representing a single task in the application.
// Contains all properties needed for task management including
// title, description, due date, priority, category, and completion status.

enum Priority { high, medium, low }

enum Category { work, personal, health, education, finance }

class Task {
  // Unique identifier for each task
  final String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  Category category;
  bool isCompleted;

  /// Constructor with required and optional parameters.
  /// The [id] is auto-generated using the current timestamp if not provided.
  Task({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Returns true if the task's due date is before today and it is not completed.
  bool get isOverdue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return dueDate.isBefore(today) && !isCompleted;
  }

  /// Returns the display name for the task's priority level.
  String get priorityLabel {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  /// Returns the display name for the task's category.
  String get categoryLabel {
    switch (category) {
      case Category.work:
        return 'Work';
      case Category.personal:
        return 'Personal';
      case Category.health:
        return 'Health';
      case Category.education:
        return 'Education';
      case Category.finance:
        return 'Finance';
    }
  }

  /// Creates a copy of this task with optional parameter overrides.
  /// Used when editing a task to preserve immutability patterns.
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    Category? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
